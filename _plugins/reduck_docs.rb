# frozen_string_literal: true

require "json"
require "rouge"

# The reader that turns a page of the content repository into what the layouts render.
#
# A page is markdown with front matter, exactly as `docs-content-template` describes it, so a file
# written for the app renders here unchanged. Three things markdown has no syntax for are read
# here rather than in a layout:
#
#   * `:::tabs` / `::tab` — alternatives a reader picks between
#   * `:::tiles` / `::tile` — a grid of links, each card clickable as a whole
#   * `:::details <summary>` — prose folded under one line, for the reader who wants more
#   * `::tiles-from <slug>` — the tiles another page owns, copied in before the page is read
#   * `::video <uid> <title>` — a Cloudflare Stream video, by its id
#
# A page also comes apart into blocks rather than into one string of HTML: a fence, a callout and
# a run of numbered steps each carry a frame of their own, which they cannot wear while they are
# still inside the prose.
module ReduckDocs
	# What a run of prose is cut at. Only one starting at the start of a line counts — an indented
	# fence belongs to the step holding it. A step runs on through every indented line that
	# follows its number, and blank lines — inside a step or between two — do not end the run, so
	# a fence or a tiles group written under a step stays inside it and the steps stay one run.
	BLOCK = /
		^```([^\n]*)\r?\n(.*?)^```[ \t]*$
		|^((?:>[^\n]*(?:\r?\n|$))+)
		|^((?:\d+\.[ \t]+[^\n]*(?:(?:\r?\n[ \t]*)*\r?\n[ \t]+[^\n]*)*(?:\r?\n[ \t]*)*(?:\r?\n|$))+)
		|^::video[ \t]+([a-f0-9]{32})(?:[ \t]+([^\n]*?))?[ \t]*$
	/mx

	# Where one numbered item ends and the next begins.
	STEP = /^\d+\.[ \t]+/

	# An item of a tight list is one run of inline markdown, and the `<p>` kramdown puts around it
	# would take the spacing the prose gives a paragraph.
	LONE_PARAGRAPH = %r{\A<p>(.*)</p>\s*\z}m

	# GitHub's alert syntax, which says what kind of callout a blockquote is. A blockquote that
	# opens with none is a note.
	ALERT = /\A\[!(NOTE|TIP|IMPORTANT|WARNING|CAUTION)\][ \t]*\r?\n?/

	ALERT_VARIANTS = {
		"NOTE" => "info",
		"IMPORTANT" => "info",
		"TIP" => "success",
		"WARNING" => "warning",
		"CAUTION" => "danger"
	}.freeze

	BANNER_ICONS = {
		"info" => "info",
		"success" => "circle-check",
		"warning" => "triangle-warning",
		"danger" => "circle-xmark"
	}.freeze

	# Only `details` takes a label — the line the group folds under.
	GROUP_OPEN = /^:::(tabs|tiles|details)(?:[ \t]+(.+?))?[ \t]*$/
	GROUP_CLOSE = /^:::[ \t]*$/
	TAB_OPENER = /^::tab[ \t]+(.+?)[ \t]*$/
	TILE_OPENER = /^::tile[ \t]+(.+?)[ \t]*$/
	TILE_LINK = /\A\[([^\]]+)\]\(([^)]+)\)(?:[ \t]+icon:([a-z0-9_-]+))?\z/i
	# The indent is kept so that a directive written under a step lands its group under that step.
	TILES_FROM = /^([ \t]*)::tiles-from[ \t]+([a-z0-9-]+)[ \t]*$/

	# The languages a grammar is loaded for; any other fence renders uncoloured, in the same frame.
	HIGHLIGHTED = %w[bash typescript json toml].freeze

	# A link written for the app, which serves the docs under a path, read on the site that serves
	# them at its root.
	APP_DOCS_LINK = %r{\]\(/docs(?:/([a-z0-9\-/]*))?(#[^)]*)?\)}

	class Reader
		# Every `/docs/…` link met while reading, with the page it sits on, for the generator to
		# check once every page — and so every heading — is known.
		attr_reader :links

		def initialize(site, index_slug)
			@site = site
			@index_slug = index_slug
			@markdown = site.find_converter_instance(Jekyll::Converters::Markdown)
			@formatter = Rouge::Formatters::HTML.new
			@links = []
		end

		# The page, as the list of blocks a layout walks.
		def blocks(slug, body, allow_tabs: true)
			out = []
			group = 0

			segments(body).each do |segment|
				case segment[:kind]
				when "text"
					prose(slug, segment[:body], out)
				when "tabs"
					unless allow_tabs
						prose(slug, ":::tabs\n#{segment[:body]}\n:::", out)
						next
					end
					tabs = tabs_of(slug, segment[:body], group)
					tabs.empty? ? prose(slug, segment[:body], out) : out << { "kind" => "tabs", "id" => "tabs-#{group}", "tabs" => tabs }
					group += 1
				when "tiles"
					tiles = tiles_of(slug, segment[:body])
					tiles.empty? ? prose(slug, segment[:body], out) : out << { "kind" => "tiles", "tiles" => tiles }
				when "details"
					# Tiles and fences, but no tabs: folded prose is already one step aside from
					# the page, and a choice inside it would be a second.
					out << {
						"kind" => "details",
						"summary" => segment[:label].to_s.strip,
						"blocks" => blocks(slug, segment[:body], allow_tabs: false)
					}
				end
			end

			out
		end

		# The tiles a page owns, for `::tiles-from` to copy. Read off the page as it was written,
		# so a page that borrows its tiles in turn holds none of its own: one hop only.
		def tiles_group(body)
			segments(body).find { |segment| segment[:kind] == "tiles" }&.fetch(:body)
		end

		# The page as one markdown document, for a reader — or an agent — to take away whole. It is
		# the source with its title put back on top and its links made absolute, so it reads the
		# same pasted anywhere.
		def markdown(doc, body)
			base = "#{@site.config["url"]}#{@site.baseurl}"
			"# #{doc.data["title"]}\n\n#{doc.data["description"]}\n\n#{rewrite_links(body.strip, base)}\n"
		end

		private

		# The body, cut into prose and groups. Counting the fences rather than matching a pair of
		# them is what lets a tiles group sit inside a tab: a non-greedy match would end the tab
		# group at the first `:::` it met, which is the inner one.
		def segments(body)
			out = []
			text = []
			group = nil

			flush = lambda do
				out << { kind: "text", body: text.join("\n") } unless text.join("\n").strip.empty?
				text = []
			end

			body.split(/\r?\n/).each do |line|
				opener = GROUP_OPEN.match(line)

				if group.nil?
					if opener
						flush.call
						group = { kind: opener[1], label: opener[2], lines: [], depth: 1 }
					else
						text << line
					end
					next
				end

				if opener then group[:depth] += 1
				elsif GROUP_CLOSE.match?(line) then group[:depth] -= 1
				end

				if group[:depth].zero?
					out << { kind: group[:kind], label: group[:label], body: group[:lines].join("\n") }
					group = nil
				else
					group[:lines] << line
				end
			end

			# A group left open at the end of the page never said where it stops, so it is prose.
			text.push(":::#{group[:kind]} #{group[:label]}".strip, *group[:lines]) if group
			flush.call
			out
		end

		# A run of markdown, cut at each fence, each callout and each run of steps. Each becomes a
		# block of its own so it can wear the frame it needs — the copy button, the callout's
		# colour, the joined dots of a numbered list.
		def prose(slug, markdown, out)
			cursor = 0
			markdown.to_enum(:scan, BLOCK).each do
				match = Regexp.last_match
				push_html(slug, markdown[cursor...match.begin(0)], out)
				cursor = match.end(0)

				info, fenced, quote, steps, video, title = match.captures

				if video
					out << { "kind" => "video", "id" => video, "title" => title.to_s.strip }
					next
				end

				if quote
					quoted = quote.gsub(/^>[ \t]?/, "").strip
					alert = ALERT.match(quoted)
					variant = alert ? ALERT_VARIANTS[alert[1]] : "info"
					out << {
						"kind" => "banner",
						"variant" => variant,
						"icon" => BANNER_ICONS[variant],
						"html" => render(slug, quoted.sub(ALERT, ""))
					}
					next
				end

				if steps
					# A step holds blocks the way a tab panel does: its first run of prose is the
					# line beside the numeral, and whatever follows — a fence, a callout, a tiles
					# group — is drawn under it, inside the step.
					items = steps.split(STEP).drop(1).map do |item|
						inner = blocks(slug, dedent(item), allow_tabs: false)
						lead = inner.first&.fetch("kind") == "html" ? inner.shift["html"] : ""
						{ "html" => LONE_PARAGRAPH.match(lead)&.captures&.first || lead, "blocks" => inner }
					end
					out << { "kind" => "steps", "items" => items } unless items.empty?
					next
				end

				lang = info.to_s.strip
				out << {
					"kind" => "code",
					"code" => fenced.to_s.sub(/\r?\n\z/, ""),
					"html" => highlight(fenced.to_s.sub(/\r?\n\z/, ""), lang)
				}
			end
			push_html(slug, markdown[cursor..], out)
		end

		# The lines under a step's number are indented to sit beneath it, which is layout in the
		# source and would read as a code block once the number is gone. Only that shared indent
		# goes, so the indentation inside a fence is kept.
		def dedent(item)
			lines = item.strip.split(/\r?\n/)
			indent = lines.drop(1).reject { |line| line.strip.empty? }.map { |line| line[/\A[ \t]*/].length }.min || 0
			[lines.first, *lines.drop(1).map { |line| line[indent..] || "" }].join("\n")
		end

		def push_html(slug, markdown, out)
			return if markdown.nil? || markdown.strip.empty?

			out << { "kind" => "html", "html" => render(slug, markdown) }
		end

		def render(slug, markdown)
			html = @markdown.convert(rewrite_links(markdown, from: slug))
			# An image is written beside the page that uses it, so its source is a bare file name.
			# The page it renders on may be served from another path — the index page answers at
			# the root — so each is resolved against the page's own folder rather than the URL.
			html.gsub(/(<img[^>]*\bsrc=")(?!https?:|data:|\/)([^"]+)(")/) do
				"#{Regexp.last_match(1)}#{@site.baseurl}/#{slug}/#{Regexp.last_match(2)}#{Regexp.last_match(3)}"
			end
		end

		# `from` is the page the markdown belongs to; given, each link is recorded for the check.
		# The markdown copy of a page passes none: its links are the page's, already recorded.
		def rewrite_links(markdown, base = @site.baseurl, from: nil)
			markdown.gsub(APP_DOCS_LINK) do
				slug = Regexp.last_match(1)
				hash = Regexp.last_match(2)
				record(from, slug, hash) if from
				"](#{base}#{path_of(slug)}#{hash})"
			end
		end

		def record(from, slug, hash)
			@links << { from: from, slug: slug.to_s.chomp("/"), hash: hash.to_s.delete_prefix("#") }
		end

		# The index page is served at the root, so a link written to it by slug has to land there
		# too: `/overview/` is an address nothing answers at.
		def path_of(slug)
			slug = slug.to_s.chomp("/")
			slug.empty? || slug == @index_slug ? "/" : "/#{slug}/"
		end

		def highlight(code, lang)
			return escape(code) unless HIGHLIGHTED.include?(lang)

			lexer = Rouge::Lexer.find_fancy(lang)
			lexer ? @formatter.format(lexer.lex(code)) : escape(code)
		end

		def escape(text)
			text.gsub("&", "&amp;").gsub("<", "&lt;").gsub(">", "&gt;")
		end

		def slugify_label(label)
			slug = label.downcase.gsub(/[^a-z0-9]+/, "-").gsub(/\A-|-\z/, "")
			slug.empty? ? "tab" : slug
		end

		def tabs_of(slug, body, group)
			parts = body.split(TAB_OPENER)
			tabs = []
			# `split` on a capturing pattern yields [before, label, content, …]; the leading run is
			# whatever sat above the first `::tab`, which has nowhere to go.
			(1...parts.length).step(2) do |i|
				label = parts[i].to_s.strip
				next if label.empty?

				tabs << {
					"id" => "tabs-#{group}-#{slugify_label(label)}",
					"label" => label,
					# Tiles only: a tab is already a choice, and a second bar of them inside one
					# would be a choice about a choice.
					"blocks" => blocks(slug, parts[i + 1].to_s, allow_tabs: false)
				}
			end
			tabs
		end

		def tiles_of(slug, body)
			parts = body.split(TILE_OPENER)
			tiles = []
			(1...parts.length).step(2) do |i|
				link = TILE_LINK.match(parts[i].to_s.strip)
				# A tile whose line is not a link has no destination, and a tile with no
				# destination is not a tile: it is dropped rather than drawn as a card that does
				# nothing.
				next unless link

				label, href, icon = link.captures
				next if label.to_s.empty? || href.to_s.empty?

				tile = {
					"label" => label,
					"href" => rewrite_href(slug, href),
					"note" => parts[i + 1].to_s.strip.gsub(/\s+/, " ")
				}
				tile["icon"] = icon if icon
				tiles << tile
			end
			tiles
		end

		def rewrite_href(from, href)
			return href unless href.start_with?("/docs")

			target, hash = href.delete_prefix("/docs").delete_prefix("/").split("#", 2)
			record(from, target, hash)
			"#{@site.baseurl}#{path_of(target)}#{hash ? "##{hash}" : ""}"
		end
	end

	class Generator < Jekyll::Generator
		safe true
		priority :high

		def generate(site)
			collection = site.collections["docs"]
			return if collection.nil?

			index_slug = site.config["index_slug"] || "overview"
			reader = Reader.new(site, index_slug)

			pages = collection.docs.map do |doc|
				slug = File.basename(File.dirname(doc.relative_path))
				doc.data["slug"] = slug
				doc.data["permalink"] = slug == index_slug ? "/" : "/#{slug}/"
				doc.content = sourced(site, doc) if doc.data["source"]
				doc
			end

			# Read first, copy second: `::tiles-from` names another page, which has to be in hand
			# before the page borrowing from it is read.
			owned = pages.to_h { |doc| [doc.data["slug"], reader.tiles_group(doc.content)] }

			pages.each do |doc|
				body = doc.content.gsub(TILES_FROM) do
					indent, name = Regexp.last_match.captures
					group = owned[name]
					if group.nil?
						Jekyll.logger.warn "Docs:", "::tiles-from names \"#{name}\", which holds no tiles group"
						""
					else
						":::tiles\n#{group}\n:::".gsub(/^/, indent)
					end
				end

				doc.data["blocks"] = reader.blocks(doc.data["slug"], body)
				doc.data["search_text"] = plain_text(doc.data["blocks"])
				doc.data["search_headings"] = headings(doc.data["blocks"])
				site.pages << markdown_page(site, doc, reader.markdown(doc, body))

				# Every layout reads `page.blocks`; leaving the markdown in place would only have
				# kramdown convert it a second time, to output nothing renders.
				doc.content = ""
			end

			check_links(reader.links, pages, index_slug)
			site.data["nav"] = nav(site, pages)
			link_next(site.data["nav"], pages)
			site.pages << search_index(site, pages)
		end

		private

		# Every `/docs/<slug>#anchor` link names a page that exists and, with an anchor, an id that
		# page renders. A miss fails the build — on the laptop, in the PR check and in the deploy
		# alike — and names the page it sits on, so the fix is one edit away. External links are
		# not looked at: they are outside this repository's control.
		# A page whose body is a document something else publishes — the CLI's README on npm —
		# fetched into `assets/` by the deploy workflow so the site never
		# holds a copy that can drift. The document's own title, and whatever sits above it (a
		# logo, badges), is dropped: the front matter is the title here. A missing file fails the
		# build, because the page would otherwise publish empty and nothing would say so.
		def sourced(site, doc)
			path = File.join(site.source, doc.data["source"])
			unless File.file?(path)
				raise Jekyll::Errors::FatalException, "#{doc.relative_path}: source \"#{doc.data["source"]}\" is not a file"
			end

			File.read(path).sub(/\A.*?^#[ \t]+[^\n]*\n/m, "")
		end

		def check_links(links, pages, index_slug)
			ids = pages.to_h do |doc|
				[doc.data["slug"], doc.data["blocks"].flat_map { |block| strings(block) }.join.scan(/\bid="([^"]+)"/).flatten]
			end

			dead = links.uniq.filter_map do |link|
				slug = link[:slug].empty? ? index_slug : link[:slug]
				if !ids.key?(slug)
					"#{link[:from]}: /docs/#{link[:slug]} — no such page"
				elsif !link[:hash].empty? && !ids[slug].include?(link[:hash])
					"#{link[:from]}: /docs/#{link[:slug]}##{link[:hash]} — #{slug} has no heading with that id"
				end
			end
			return if dead.empty?

			raise Jekyll::Errors::FatalException, "Dead links:\n  #{dead.join("\n  ")}"
		end

		# The nav panel: the published pages grouped under their section, each section in the order
		# the config fixes and each page in the order its front matter asked for. A section no page
		# claims is left out, so an empty heading never renders.
		def nav(site, pages)
			listed = pages.reject { |doc| doc.data["draft"] }
				.sort_by { |doc| [doc.data["order"].to_i, doc.data["title"].to_s] }

			nested = site.config["nested_under"] || {}
			sections = (site.config["sections"] || []).map do |section|
				{
					"id" => section["id"],
					"label" => section["label"],
					"pages" => listed.select { |doc| doc.data["section"] == section["id"] }.map { |doc| entry(doc) }
				}
			end

			nested.each do |section_id, hub_slug|
				group = sections.find { |section| section["id"] == section_id }
				hub = sections.flat_map { |section| section["pages"] }.find { |page| page["slug"] == hub_slug }
				next if group.nil? || group["pages"].empty? || hub.nil?

				hub["children"] = group["pages"]
				group["pages"] = []
			end

			sections.reject { |section| section["pages"].empty? }
		end

		def entry(doc)
			{
				"slug" => doc.data["slug"],
				"title" => doc.data["title"],
				"url" => doc.url,
				"section" => doc.data["section"]
			}
		end

		# The page that follows this one in the panel, reading the sections top to bottom as a
		# single list. The last page of the docs has none, and so shows no way on.
		def link_next(sections, pages)
			flat = sections.flat_map { |section| section["pages"].flat_map { |page| [page, *(page["children"] || [])] } }
			by_slug = pages.to_h { |doc| [doc.data["slug"], doc] }

			flat.each_with_index do |page, i|
				following = flat[i + 1]
				next if following.nil?

				by_slug[page["slug"]]&.data&.[]=("next_page", following)
			end
		end

		# The page's markdown, served beside its HTML as `index.md`: what the copy button on the
		# page takes, and what an agent asks for when it wants the page and not the shell around
		# it. Named `.txt` on the way in because a name ending in `.md` would be handed to kramdown
		# and come out as HTML; the permalink is what gives it its address.
		def markdown_page(site, doc, text)
			page = Jekyll::PageWithoutAFile.new(site, site.source, "", "index.txt")
			page.content = text
			page.data["layout"] = nil
			page.data["permalink"] = "#{doc.data["permalink"]}index.md"
			page.data["sitemap"] = false
			page
		end

		def search_index(site, pages)
			entries = pages.reject { |doc| doc.data["draft"] || doc.data["search"] == false }.map do |doc|
				{
					url: doc.url,
					title: doc.data["title"],
					section: doc.data["section"],
					headings: doc.data["search_headings"],
					text: doc.data["search_text"]
				}
			end

			page = Jekyll::PageWithoutAFile.new(site, site.source, "", "search.json")
			page.content = JSON.generate(entries)
			page.data["layout"] = nil
			page.data["sitemap"] = false
			page
		end

		def plain_text(blocks)
			blocks.flat_map { |block| strings(block) }
				.join(" ")
				.gsub(/<[^>]+>/, " ")
				.gsub(/&[a-z]+;/, " ")
				.gsub(/\s+/, " ")
				.strip
		end

		def strings(block)
			case block["kind"]
			when "html", "banner" then [block["html"]]
			when "steps" then block["items"].flat_map { |item| [item["html"], *item["blocks"].flat_map { |inner| strings(inner) }] }
			when "code" then [block["code"]]
			when "tabs" then block["tabs"].flat_map { |tab| [tab["label"], *tab["blocks"].flat_map { |inner| strings(inner) }] }
			when "tiles" then block["tiles"].flat_map { |tile| [tile["label"], tile["note"]] }
			when "details" then [block["summary"], *block["blocks"].flat_map { |inner| strings(inner) }]
			when "video" then [block["title"]]
			else []
			end
		end

		# `h2` and `h3` are what a page's structure is, so they rank a hit above the prose under
		# them and below the title.
		def headings(blocks)
			blocks.select { |block| block["kind"] == "html" }
				.flat_map { |block| block["html"].scan(%r{<h[23][^>]*>(.*?)</h[23]>}m) }
				.flatten
				.map { |heading| heading.gsub(/<[^>]+>/, "").strip }
				.reject(&:empty?)
		end
	end
end
