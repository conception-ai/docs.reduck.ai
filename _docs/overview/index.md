---
title: Overview
description: Reduck turns any website into a tool your agent can call — a reusable browser script that returns structured data.
section: get-started
order: 10
---

Most of what a team needs is on a website, not behind an API. Reduck closes that gap: it turns a
flow on a site — a search, an export, a form, a download — into a **script** your agent can call
and get JSON back from.

An agent connects to Reduck once. From then on it can find a script, run it, and read the result,
without you writing selectors or maintaining a scraper.

## What a script is

A script is deterministic code that automates one flow on one site. It declares what it takes and
what it returns, so calling it is like calling a function:

```json
{
	"script": {
		"handle": "reduck",
		"host": "airbnb.com",
		"slug": "search",
		"args": { "city": "Lisbon", "guests": 2, "maxPrice": 150 }
	}
}
```

A script is addressed by the site it automates and the flow it covers —
`[<handle>/]<host>/<slug>`. A bare address is your own script; `reduck/` is the
[official library](/docs/official-library); `@someone/` is that person's.

Reduck maintains an [official library](/docs/official-library) of scripts for common sites, and
your agent can [write new ones](/docs/scripts) for sites the library does not cover yet.

## Where a script runs

Every run happens in a real browser — which is why Reduck works on sites with no API and on pages
behind a login. You choose whose browser:

- **Your own Chrome**, through the Reduck extension. The script inherits the sites you are already
  signed into, and your credentials never leave the machine.
- **A managed browser** that Reduck hosts, for automation that has to run when your laptop is
  closed.

[Browsers](/docs/browsers) covers the trade-off between them.

## Three ways in

| You want                                            | Use                                                          |
| --------------------------------------------------- | ------------------------------------------------------------ |
| An agent that finds and runs scripts for you        | [The MCP server](/docs/mcp-tools)                            |
| Scripts in a terminal, or piped into something else | [The CLI](/docs/cli)                                         |
| Calls from your own code                            | [The REST API](/docs/api-reference) and [its SDK](/docs/sdk) |

[Quick start](/docs/quick-start) sets up whichever of the three you want, in a few minutes.
