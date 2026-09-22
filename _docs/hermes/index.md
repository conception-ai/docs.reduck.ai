---
title: Hermes
description: Add the Reduck MCP server to Hermes, and point it at your own model provider.
section: connect
order: 70
---

Hermes installs from a script and reaches Reduck over OAuth.

## Before you start

You need a Reduck account, and a paired browser if you want scripts to run on your own Chrome.
Both are in the [quick start](/docs/overview#quick-start).

Hermes needs a model provider of its own — it ships with none.

```bash
curl -fsSL https://hermes-agent.nousresearch.com/install.sh | bash
```

## Add the server

```bash
hermes mcp add reduck \
  --url https://mcp.reduck.ai \
  --auth oauth
```

Then authorize:

```bash
hermes mcp login reduck
```

> [!WARNING]
> Run that in a real terminal. `hermes mcp login`, `hermes model` and `hermes tools` all refuse to
> run through a pipe or a script.

## Confirm it is connected

```bash
hermes mcp test reduck
```

It reports the server as connected, with 25 tools discovered.

The OAuth flow signs you in as whichever Reduck account your browser is already using, which is
not always the one you meant. Ask your agent to call `whoami` and read the handle back before you
rely on it.

## Settings worth changing

Hermes ships routed through OpenRouter. If `hermes model` lists aggregator catalogues, or warns
that there is no active subscription, name your provider in `~/.hermes/config.yaml` and remove any
`base_url` entry:

```yaml
model:
    provider: anthropic
```

## Run your first script

Connecting the agent is not the last step of setup — a run is. Ask your agent to do something on a
website, and it searches the official library, picks the scripts it needs, and runs them for you.

```text
Use Reduck to fetch the latest X.com reposts by Reduck AI
```

Once it runs, finish setup at [reduck.ai/setup](https://reduck.ai/setup).

## If it does not appear

- The command was run through a pipe or a script. Hermes refuses several of its commands outside
  an interactive terminal.
- Sign-in never finished. `hermes mcp login reduck` has to complete in the browser before any tool
  call works.
- No model provider is set, so the agent answers nothing even with the tools connected. See above.
