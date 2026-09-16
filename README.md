# docs.reduck.ai

The Reduck documentation, as a Jekyll site on GitHub Pages. A page is markdown with front matter;
the shell around it — the header, the nav panel, the prose styles and the ⌘K palette — lives here
too, so a change to the wording is a push and nothing else.

## Run it locally

```sh
bundle install
bundle exec jekyll serve
```

Then open <http://127.0.0.1:4000>. An edit shows on the next reload — `serve` watches the folder
and rebuilds. Ruby 3.3 or later, and nothing else.

```sh
bundle exec jekyll build              # write _site/ once, without serving
bundle exec jekyll serve --port 4001  # when 4000 is taken
```

`/api-reference` reads `assets/openapi.json`, which is committed, so it works offline too. It is
refreshed on every deploy — see below.

## Writing a page

One folder per page under `_docs/`, holding `index.md` and any images it uses. The folder name is
the slug, so `_docs/install-the-extension/` is served at `/install-the-extension`.

```markdown
---
title: Install the extension
description: Pair your own Chrome with your Reduck account as a device.
section: get-started
order: 20
---

The prose starts here.
```

| Field         | Required | What it does                                                             |
| ------------- | -------- | ------------------------------------------------------------------------ |
| `title`       | yes      | The page heading, and its entry in the nav panel                         |
| `description` | yes      | The meta description, and the subtitle on a search hit                   |
| `section`     | yes      | `get-started`, `connect`, `core-concepts`, `using-reduck` or `security`  |
| `order`       | yes      | Position in the nav panel, ascending. Leave gaps — 10, 20, 30            |
| `draft`       | no       | `true` keeps it out of the nav, the sitemap and the search index         |

`_docs/overview/` is special: it is served at `/`, not at `/overview`, because it is where a
reader lands. Give it the lowest `order` so it leads the nav.

The five sections are fixed in `_config.yml`. A page names one; it cannot invent one.

## Images

Keep an image beside the markdown that uses it and reference it by name:

```markdown
![The pairing prompt](pairing.png)
```

It is published beside the page, so nothing else has to be kept in step.

## Tabs and tiles

Two things markdown has no syntax for. Both run from an opening fence to a bare `:::`.

**Tabs** — alternatives a reader picks between, where each is a page of its own worth of prose:

```markdown
:::tabs
::tab Reduck MCP (Recommended)
Prose, code fences, anything.
::tab Reduck CLI
...
:::
```

**Tiles** — a grid of links, each card clickable as a whole. A tile's line is an ordinary markdown
link, and `icon:` names a brand mark in `assets/img/brands`. The line under it is a few words, not
prose:

```markdown
:::tiles
::tile [Claude Code](/claude-code) icon:claudecode
One command
::tile [ChatGPT](/chatgpt) icon:chatgpt
Custom connector
:::
```

A tiles group can sit inside a tab. A tabs group inside a tab is not read as one, and stays on the
page as the text it is. A group with nothing readable in it renders as plain text rather than as
an empty bar or grid, so a typo shows rather than disappears.

Every fenced code block gets a copy button. Nothing else does — a fence is the thing a reader
copies, and a button on each paragraph would be noise.

### Showing another page's tiles

Two pages listing the same tiles drift the moment one of them gains an entry. Where a second page
needs the same set, name the page that owns them instead of copying the group:

```markdown
::tiles-from connect-your-agent
```

The group is copied in before the page is read, so it behaves like an ordinary `:::tiles` group
from then on — including inside a tab. One hop only: the page you name is read as written, so it
has to hold the tiles itself rather than borrow them in turn.

## What renders

GFM: headings, lists, tables, blockquotes, images, links, and fenced code. Fences in `bash`,
`typescript`, `json` and `toml` are highlighted; any other language renders in the same frame,
uncoloured.

A blockquote is a callout. GitHub's alert syntax says which kind:

```markdown
> [!WARNING]
> Codex Pro is required.
```

`NOTE` and `IMPORTANT` read as a note, `TIP` as a success, `WARNING` as a warning, `CAUTION` as a
danger. A blockquote that opens with none is a note.

A run of numbered lines is drawn as joined steps rather than as an ordinary list.

`h2` and `h3` are what the search index reads as a page's structure, so use them to break a page up
rather than jumping to `h4`.

A link written as `/docs/<slug>` — the shape the app used when it served these pages under a path
— is rewritten to `/<slug>/`, so prose can move between the two without editing.

## The API reference

`/api-reference` is Scalar over the app's OpenAPI document. The app serves that document without
CORS headers, so a browser here cannot read it: `.github/workflows/pages.yml` fetches it on every
build and the copy in `assets/openapi.json` is what the page opens. The build also runs daily, so
an endpoint added to the app shows up here without a push.

## Publishing

Push to `main`. GitHub Actions builds the site and deploys it to Pages, at `docs.reduck.ai`.

## Layout

| Path                      | What it holds                                                    |
| ------------------------- | ----------------------------------------------------------------- |
| `_docs/`                  | One folder per page: the markdown and the images beside it       |
| `_plugins/reduck_docs.rb` | The reader: tabs, tiles, callouts, steps, the nav tree, the index |
| `_layouts/`, `_includes/` | The shell — the site header, the docs bar, the panel, the palette |
| `assets/css/`             | `tokens.css` is the app's palette and type scale, restated        |
