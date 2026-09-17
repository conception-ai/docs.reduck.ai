// The behaviour the chrome needs on every page: the copy button — the one a fenced block carries,
// and the one a page carries for its markdown.
(() => {
	"use strict";

	// The icon is swapped rather than re-rendered: the button holds one SVG, and only the paths
	// inside it change.
	const TICK = "M4 12.5 9 17.5 20 6.5";

	// What a copy button copies: the document at the address it names, or, bare, the fence beside
	// it. A page's markdown is fetched at the click rather than carried in the HTML, so a reader
	// who never copies never downloads it.
	async function textOf(button) {
		const url = button.getAttribute("data-copy");
		if (url) {
			const response = await fetch(url);
			if (!response.ok) throw new Error(`${url} answered ${response.status}`);
			return response.text();
		}
		const code = button.parentElement?.querySelector("pre");
		if (!code) throw new Error("no fence beside the copy button");
		return code.innerText;
	}

	document.addEventListener("click", async (event) => {
		const button = event.target.closest("[data-copy]");
		if (!button) return;

		try {
			await navigator.clipboard.writeText(await textOf(button));
		} catch {
			return;
		}

		const svg = button.querySelector("svg");
		if (!svg) return;

		const before = svg.innerHTML;
		svg.innerHTML = `<path d="${TICK}"/>`;
		setTimeout(() => {
			svg.innerHTML = before;
		}, 2000);
	});
})();
