---
title: Claude Code
description: Add the Reduck MCP server to Claude Code with one command, scoped to the machine or to a single project, and confirm it with /mcp.
section: connect
order: 10
---

Claude Code reads MCP servers from its own config, so one command is the whole install.

## Before you start

You need a Reduck account, and a paired browser if you want scripts to run on your own Chrome.
Both are in the [quick start](/docs/overview#quick-start).

## Add the server

```bash
claude mcp add reduck --transport http --scope user https://mcp.reduck.ai
```

`--scope user` makes Reduck available in every project on this machine. Drop it to add Reduck to
the current project only.

Restart Claude Code so it picks the server up.

## Confirm it is connected

Run `/mcp` in a session. Reduck is listed, and the first call opens a browser to sign in to your
Reduck account.

```bash
claude mcp list
```

lists the same thing from a terminal, without starting a session.

## If it does not appear

- The server is added but Claude Code was not restarted. A running session does not pick up a new
  server.
- The transport is wrong. Reduck speaks streamable HTTP, so `--transport http` is required — the
  default is stdio, which expects a command to launch rather than a URL.
- The entry is there but stale. Remove it with `claude mcp remove reduck` and add it again.
