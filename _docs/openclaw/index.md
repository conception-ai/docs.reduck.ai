---
title: OpenClaw
description: Add the Reduck MCP server to OpenClaw over streamable HTTP, keep its local gateway alive, and bring the model provider it ships without.
section: connect
order: 60
---

OpenClaw reaches Reduck over streamable HTTP, and runs it through a local gateway of its own.

## Before you start

You need a Reduck account, and a paired browser if you want scripts to run on your own Chrome.
Both are in the [quick start](/docs/overview#quick-start).

OpenClaw needs **Node 20 or later**, and a model provider of its own — it ships with none.

```bash
npm i -g openclaw
```

## Add the server

```bash
openclaw mcp add reduck \
  --url https://mcp.reduck.ai \
  --auth oauth \
  --transport streamable-http
```

> [!WARNING]
> `--transport streamable-http` is required. Without it OpenClaw negotiates SSE and fails with
> `SSE error: Non-200 status code (400)`, which reads like an authorization failure and is not.

Then authorize. This opens your browser; approve the request and the CLI picks up the callback.

```bash
openclaw mcp login reduck
```

## Confirm it is connected

```bash
openclaw mcp probe
```

A working connection reports **25 tools**.

The OAuth flow signs you in as whichever Reduck account your browser is already using, which is
not always the one you meant. Ask your agent to call `whoami` and read the handle back before you
rely on it.

## Settings worth changing

OpenClaw asks for approval before each tool call, which interrupts a script mid-run. To let Reduck
run unattended:

```bash
openclaw mcp configure reduck --approval auto
```

OpenClaw reaches the server through a local gateway. Install it as a daemon to keep it alive after
the terminal closes:

```bash
openclaw onboard --install-daemon
```

## Run your first script

Connecting the agent is not the last step of setup — a run is. Ask your agent to do something on a
website, and it searches the official library, picks the scripts it needs, and runs them for you.

```text
Use Reduck to fetch the latest X.com reposts by Reduck AI
```

Once it runs, finish setup at [reduck.ai/setup](https://reduck.ai/setup).

## If it does not appear

- The transport was left out, so the connection failed as SSE. See the warning above — the error
  names a status code, not the flag that caused it.
- Node is older than 20.
- Sign-in never finished. `openclaw mcp login reduck` has to complete in the browser before any
  tool call works.
