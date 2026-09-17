---
title: Using Reduck
description: Three ways to run a script — through your agent over MCP, from a terminal with the CLI, or from your own code over the REST API — and when to use which.
section: get-started
order: 28
---

Every script can be reached three ways. They run the same scripts on the same browsers; what
differs is who is calling.

| You want                                            | Use                             |
| --------------------------------------------------- | ------------------------------- |
| An agent that finds and runs scripts for you        | [MCP](/docs/mcp)                |
| Scripts in a terminal, in parallel, or piped onward | [The CLI](/docs/cli)            |
| Calls from your own code, a cron, or an orchestrator | [The REST API](/docs/api)      |

**MCP** is the way in most people want: nothing to install, and the agent discovers, reads and runs
scripts on its own. **The CLI** is for when you are the one at the keyboard, or when a script's
output has to land on disk. **The API** is for a caller that has an HTTP client and nothing else:
a backend, a headless job, a tool such as n8n. It is also the door built for
[managed browsers](/docs/core-concepts#browser).
