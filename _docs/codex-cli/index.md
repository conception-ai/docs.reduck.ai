---
title: Codex CLI
description: Add the Reduck MCP server to the Codex command line, pin the Codex release Reduck is tested against, and let scripts run without an approval prompt.
section: connect
order: 30
---

Codex reads MCP servers from `~/.codex/config.toml`, and its own `codex mcp` command writes that
file for you.

> [!WARNING]
> **Codex Pro is required.** MCP servers are not available to free Codex accounts.

## Before you start

You need a Reduck account, and a paired browser if you want scripts to run on your own Chrome.
Both are in the [quick start](/docs/overview#quick-start).

Install the Codex version Reduck is tested against:

```bash
npm i -g @openai/codex@0.141.0
```

Pin that version. Later releases have broken the connection to Reduck.

## Add the server

```bash
codex mcp add reduck --url https://mcp.reduck.ai
```

## Confirm it is connected

Run `/mcp` in a session. Reduck is listed, and the first call opens a browser to sign in to your
Reduck account.

## Settings worth changing

Codex asks for approval before each tool call, which interrupts a script mid-run. To let Reduck
run unattended, set the approval mode for the server in `~/.codex/config.toml`:

```toml
[mcp_servers.reduck]
url = "https://mcp.reduck.ai"
default_tools_approval_mode = "auto"
```

This applies to Reduck alone; every other server keeps asking.

To lift approvals for one session instead, start Codex with `codex --full-auto` — sandbox
`workspace-write`, approval `on-failure`. That choice lasts only as long as the session.

## If it does not appear

- The account is on the free tier. Codex Pro is required for MCP servers.
- Codex is a version other than `0.141.0`. Reinstall the pinned version above.
- Sign-in never finished. The browser tab that opens on the first call has to be completed before
  any tool works.
