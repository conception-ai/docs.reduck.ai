---
title: Other clients
description: Connect any MCP-capable agent to Reduck with the transport, URL and scope it needs.
section: connect
order: 900
---

Reduck is a remote MCP server, so any client that speaks MCP over streamable HTTP can use it.
There is nothing to install and no package to run.

## Before you start

You need a Reduck account, and a paired browser if you want scripts to run on your own Chrome.
Both are in the [quick start](/docs/overview#quick-start).

## Let your agent do it

Most harnesses can add a server to their own config when asked. Paste this:

```
Install reduck MCP scoped to the user, which uses http transport at https://mcp.reduck.ai
```

## Add the server by hand

If you are writing the config yourself, this is everything the client needs:

| Setting   | Value                              |
| --------- | ---------------------------------- |
| URL       | `https://mcp.reduck.ai`            |
| Transport | Streamable HTTP — not stdio, not SSE |
| Name      | `reduck`                           |
| Scope     | User, so every project sees it     |
| Auth      | OAuth. The client opens a browser on first use |

Reduck holds no API key for MCP. The client signs in through your browser and keeps the token it
gets back. For a server-to-server caller that cannot open a browser, use an
[API key](/docs/api-reference) against the REST API instead.

## Confirm it is connected

Restart the client, then ask it to list the tools it has. `discover_scripts` and `run_script` are
the two that say Reduck is live.

## If it does not appear

- The client was not restarted after the config changed.
- The transport is set to stdio. A stdio client expects a command to launch, and Reduck is a URL.
- Sign-in never finished. The browser tab has to be completed before any tool call works.
