// The documentation shell: the panel on a narrow window, a hub's disclosure, the tab groups, and
// the palette ⌘K opens.
(() => {
	"use strict";

	const BASE = document.documentElement.dataset.baseurl || "";

	/* ------------------------------------------------------------ the panel */

	const navToggle = document.querySelector("[data-nav-toggle]");
	const nav = document.getElementById("docs-nav");
	const scrim = document.querySelector("[data-nav-scrim]");

	function setNav(open) {
		nav?.classList.toggle("open", open);
		scrim?.classList.toggle("open", open);
		navToggle?.setAttribute("aria-expanded", String(open));
		navToggle?.setAttribute("aria-label", open ? "Close navigation" : "Open navigation");
	}

	navToggle?.addEventListener("click", () => setNav(!nav?.classList.contains("open")));
	scrim?.addEventListener("click", () => setNav(false));

	for (const button of document.querySelectorAll("[data-disclosure]")) {
		button.addEventListener("click", () => {
			const open = button.getAttribute("aria-expanded") !== "true";
			button.setAttribute("aria-expanded", String(open));
			const list = document.getElementById(button.getAttribute("aria-controls"));
			if (list) list.hidden = !open;
		});
	}

	/* ------------------------------------------------------------ tab groups */

	for (const group of document.querySelectorAll("[data-tabs]")) {
		group.addEventListener("click", (event) => {
			const tab = event.target.closest("[data-tab]");
			if (!tab) return;

			// The anchor names the panel so the label still says what it selects, but selecting
			// one is a change of state, not a jump down the page.
			event.preventDefault();

			const chosen = tab.dataset.tab;
			for (const other of group.querySelectorAll("[data-tab]")) {
				other.classList.toggle("toggled", other.dataset.tab === chosen);
			}
			for (const panel of group.querySelectorAll(".panel")) {
				panel.hidden = panel.id !== chosen;
			}
		});
	}

	/* ------------------------------------------------------------ the palette */

	// How many hits the panel shows. Past this the query is the thing to narrow, not the list.
	const MAX_HITS = 8;

	// Characters either side of the matched term in the line quoted under a hit.
	const SNIPPET_RADIUS = 90;

	const SECTION_LABELS = JSON.parse(
		document.querySelector("[data-section-labels]")?.textContent || "{}"
	);

	const dialog = document.querySelector("[data-search-dialog]");
	const input = document.querySelector("[data-search-input]");
	const results = document.querySelector("[data-search-results]");
	const trigger = document.querySelector("[data-search-trigger]");
	const chord = document.querySelector("[data-search-chord]");

	// The chord the page listens for is Meta on a Mac and Control everywhere else, so the hint has
	// to say which. The build has no platform to read, and writes the Mac spelling.
	if (chord && !/mac|iphone|ipad/i.test(navigator.platform || navigator.userAgent)) {
		chord.textContent = "Ctrl K";
	}

	let index = null;
	let failed = false;
	let hits = [];
	let active = 0;

	// Fetched on the first open rather than with the page: a reader who never searches should not
	// pay for the corpus, and one who does pays once for the whole visit.
	async function load() {
		if (index || failed) return;
		try {
			const response = await fetch(`${BASE}/search.json`);
			if (!response.ok) throw new Error(`search.json answered ${response.status}`);
			index = await response.json();
		} catch (error) {
			console.error("Docs: the search index could not be read:", error);
			failed = true;
		}
		render();
	}

	function open() {
		if (!dialog || dialog.open) return;
		dialog.showModal();
		if (input) input.value = "";
		hits = [];
		active = 0;
		render();
		input?.focus();
		void load();
	}

	function close() {
		if (dialog?.open) dialog.close();
	}

	function snippetOf(text, term) {
		const at = text.toLowerCase().indexOf(term);
		if (at === -1) return text.slice(0, SNIPPET_RADIUS * 2);

		const from = Math.max(0, at - SNIPPET_RADIUS);
		const to = Math.min(text.length, at + term.length + SNIPPET_RADIUS);
		return `${from > 0 ? "…" : ""}${text.slice(from, to)}${to < text.length ? "…" : ""}`;
	}

	/**
	 * Every term has to appear somewhere on the page, and where it appears is what ranks it: a
	 * title is what the page is about, a heading what a part of it is about, the prose only that
	 * the word is present.
	 */
	function search(query) {
		const terms = query
			.toLowerCase()
			.split(/\s+/)
			.filter((term) => term.length > 1);

		if (!index || terms.length === 0) return [];

		return index
			.map((entry) => {
				const title = entry.title.toLowerCase();
				const headings = entry.headings.join(" ").toLowerCase();
				const text = entry.text.toLowerCase();

				let score = 0;
				for (const term of terms) {
					if (title.includes(term)) score += 10;
					else if (headings.includes(term)) score += 4;
					else if (text.includes(term)) score += 1;
					else return null;
				}
				return { entry, score, snippet: snippetOf(entry.text, terms[0] ?? "") };
			})
			.filter(Boolean)
			.sort((a, b) => b.score - a.score || a.entry.title.localeCompare(b.entry.title))
			.slice(0, MAX_HITS);
	}

	function escape(text) {
		const node = document.createElement("span");
		node.textContent = text;
		return node.innerHTML;
	}

	function render() {
		if (!results) return;

		const query = input?.value.trim() ?? "";

		if (failed) {
			results.innerHTML = '<p class="empty">Search is unavailable right now.</p>';
			return;
		}
		if (!index) {
			results.innerHTML = '<p class="empty">Loading…</p>';
			return;
		}
		if (query.length === 0) {
			hits = [];
			results.innerHTML = '<p class="empty">Type to search the documentation.</p>';
			return;
		}

		hits = search(query);
		if (hits.length === 0) {
			results.innerHTML = `<p class="empty">No page matches “${escape(query)}”.</p>`;
			return;
		}

		results.innerHTML = `<ul>${hits
			.map(
				(hit, i) => `<li><a class="${i === active ? "active" : ""}" href="${hit.entry.url}">
					<span class="row">
						<span class="title">${escape(hit.entry.title)}</span>
						<span class="section">${escape(SECTION_LABELS[hit.entry.section] ?? "")}</span>
					</span>
					<span class="snippet">${escape(hit.snippet)}</span>
				</a></li>`
			)
			.join("")}</ul>`;
	}

	function highlight(next) {
		if (hits.length === 0) return;
		active = (next + hits.length) % hits.length;
		const rows = results.querySelectorAll("a");
		rows.forEach((row, i) => row.classList.toggle("active", i === active));
		rows[active]?.scrollIntoView({ block: "nearest" });
	}

	trigger?.addEventListener("click", open);
	trigger?.addEventListener("focus", open);

	input?.addEventListener("input", () => {
		active = 0;
		render();
	});

	results?.addEventListener("mouseover", (event) => {
		const row = event.target.closest("a");
		if (!row) return;
		highlight(Array.from(results.querySelectorAll("a")).indexOf(row));
	});

	dialog?.addEventListener("click", (event) => {
		// The dialog holds no cross, so the backdrop is what closes it: the click that lands on
		// the dialog itself rather than on anything within it.
		if (event.target === dialog) close();
	});

	dialog?.addEventListener("keydown", (event) => {
		if (event.key === "ArrowDown") {
			event.preventDefault();
			highlight(active + 1);
		} else if (event.key === "ArrowUp") {
			event.preventDefault();
			highlight(active - 1);
		} else if (event.key === "Enter") {
			event.preventDefault();
			const hit = hits[active];
			if (hit) window.location.href = hit.entry.url;
		}
	});

	window.addEventListener("keydown", (event) => {
		if ((event.metaKey || event.ctrlKey) && event.key === "k") {
			event.preventDefault();
			open();
		}
	});
})();
