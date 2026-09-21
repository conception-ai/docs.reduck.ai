---
title: Gemini CLI
description: Add the Reduck MCP server to Gemini CLI with one command, and get past the folder trust gate.
section: connect
order: 80
---

Gemini CLI adds MCP servers from the command line and writes them to its own settings file.

## Before you start

You need a Reduck account, and a paired browser if you want scripts to run on your own Chrome.
Both are in the [quick start](/docs/overview#quick-start).

Gemini CLI needs a model provider of its own — a Google account or an API key. Reduck does not
provide one.

```bash
npx @google/gemini-cli@latest --version
```

## Add the server

```bash
gemini mcp add reduck https://mcp.reduck.ai --transport http --scope user
```

`--scope user` makes Reduck available in every folder. Drop it and the server is written to
`.gemini/settings.json` in the current project only.

> [!WARNING]
> `--transport http` is required. The default is `stdio`, which expects a command to launch rather
> than a URL, and the connection then never establishes.

## Trust the folder, or nothing loads

Gemini CLI will not start MCP servers in a folder you have not trusted — **including servers you
added with `--scope user`**. The warning is easy to read past:

```
Warning: MCP servers are configured but disabled because this folder is untrusted.
User-level servers are also suppressed in untrusted folders to prevent accidental side-effects.
```

`gemini mcp list` shows `Disabled` rather than `Disconnected` in that state. Trust the folder when
Gemini CLI offers, or run `/permissions trust` in a session, and the server loads.

## Confirm it is connected

```bash
gemini mcp list
```

Three states, and they mean different things:

| State | What it means |
| --- | --- |
| `Disabled` | The folder is untrusted. See above. |
| `Disconnected` | Loaded, not authorized yet. Authorize from a session. |
| `Connected` | Working. |

Authorize from inside a session with `/mcp auth reduck`. It opens your browser; approve the
request and the tools register.

## Settings worth changing

Written by hand, the full entry looks like this:

```json
{
  "mcpServers": {
    "reduck": {
      "url": "https://mcp.reduck.ai",
      "type": "http",
      "timeout": 600000,
      "trust": false
    }
  }
}
```

- **`timeout`** is in milliseconds and defaults to ten minutes, which is comfortable for a script
  that loads a real page. There is no reason to lower it.
- **`trust: true`** skips the confirmation before each tool call. Worth it for scheduled runs,
  and not otherwise.
- **`includeTools`** narrows what Reduck puts in context. `run_script`, `list_scripts` and
  `read_script` are enough for running the catalogue; the rest of the 30 tools are for authoring.

On versions of Gemini CLI before the `type` field, the same entry uses `httpUrl` instead of `url`.

## Run without a browser

OAuth needs a browser to complete, so it will not finish in CI or a container. Send an
[API key](/docs/api-reference) as a header instead — the MCP endpoint accepts one:

```json
{
  "mcpServers": {
    "reduck": {
      "url": "https://mcp.reduck.ai",
      "type": "http",
      "headers": { "X-API-Key": "$REDUCK_API_KEY" }
    }
  }
}
```

`$VAR` in a header is expanded from the environment, so the key does not sit in the file.

## If it does not appear

- The folder is untrusted, and `--scope user` did not save you. See above.
- The transport was left at `stdio`. Reduck is a URL, not a command.
- Sign-in never finished. `/mcp auth reduck` has to complete in the browser before any tool call
  works.
