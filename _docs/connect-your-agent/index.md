---
title: Connect your agent
description: Add the Reduck MCP server to Claude Code, Claude Desktop, Codex, ChatGPT or any other MCP client.
section: get-started
order: 25
---

Reduck is a remote MCP server at `https://mcp.reduck.ai`. There is nothing to install and no
package to run: your client signs in through your browser the first time it calls a tool, and the
Reduck tools appear beside its own.

## Pick your client

:::tiles
::tile [Claude Code](/docs/claude-code) icon:claudecode
One command
::tile [Claude Desktop and web](/docs/claude-desktop) icon:claude
Custom connector
::tile [Codex CLI](/docs/codex-cli) icon:codex
Codex Pro required
::tile [Codex Desktop](/docs/codex-desktop) icon:codex
Codex Pro required
::tile [ChatGPT](/docs/chatgpt) icon:chatgpt
Custom connector
::tile [OpenClaw](/docs/openclaw) icon:openclaw
Streamable HTTP required
::tile [Hermes](/docs/hermes) icon:hermesagent
Interactive terminal
::tile [Any other agent](/docs/other-clients)
Streamable HTTP
:::

## What every client needs

Whichever one you use, the same four facts apply.

| Setting   | Value                                          |
| --------- | ---------------------------------------------- |
| URL       | `https://mcp.reduck.ai`                        |
| Transport | Streamable HTTP — not stdio, not SSE           |
| Scope     | User, so every project sees it                 |
| Auth      | OAuth. The client opens a browser on first use |

> [!NOTE]
> A client that was running when you added the server does not pick it up. Restart it, then ask it
> to list its tools — `discover_scripts` and `run_script` are the two that say Reduck is live.

## Other ways in

MCP is the way in most agents want, but not the only one. The [CLI](/docs/cli) runs scripts from a
terminal and writes each result to disk, and the [REST API](/docs/api-reference) calls them over
HTTP with nothing to install.
