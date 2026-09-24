---
title: Cursor
description: Add the Reduck MCP server to Cursor with a two-line config file, and authorize it from Customize.
section: connect
order: 90
---

Cursor reads MCP servers from a JSON file. There is no command to run: you write the file, then
authorize from Customize.

## Before you start

You need a Reduck account, and a paired browser if you want scripts to run on your own Chrome.
Both are in the [quick start](/docs/overview#quick-start).

## Add the server

Write `~/.cursor/mcp.json` to make Reduck available in every project:

```json
{
  "mcpServers": {
    "reduck": {
      "url": "https://mcp.reduck.ai"
    }
  }
}
```

For one project only, the same content goes in `.cursor/mcp.json` at the root of that project.

That is the whole entry. Cursor infers streamable HTTP from the `url` key, and Reduck needs no
client id and no scopes in the file — it registers Cursor as an OAuth client on its own the first
time they talk.

## Authorize

Open **Customize** in Cursor's sidebar and filter to **MCPs**. Reduck is listed under
**Needs Attention**, as *Needs authentication*. Click **Authenticate**, approve the request in the
browser, and the tools register.

![Reduck listed under Needs Attention, waiting to be authenticated](needs-authentication.png)

Until you do, the server has an empty tool list — which looks like a broken config and is not
one.

> [!NOTE]
> Older versions of Cursor kept this under **Settings → MCP**. Plugins, MCPs, Skills and Rules
> have since moved to **Customize**; Cursor shows a notice in Settings pointing there.

## Confirm it is connected

Reduck moves to **Connected** and its entry reports the tool count once authorization completes.

![Reduck connected, with 30 tools enabled](connected.png)

Then ask Cursor, in a chat, to call `whoami`. It reports the Reduck account and handle it is signed in as, which is the
part worth checking: the OAuth flow signs you in as whichever Reduck account your browser is
already using, not necessarily the one you meant.

## Run without a browser

Cloud Agents and CI have no browser to complete OAuth in. Send an
[API key](/docs/api-reference) as a header instead:

```json
{
  "mcpServers": {
    "reduck": {
      "url": "https://mcp.reduck.ai",
      "headers": {
        "X-API-Key": "${env:REDUCK_API_KEY}"
      }
    }
  }
}
```

`${env:NAME}` is expanded from the environment, so the key does not sit in the file. Remote
servers do not read Cursor's `envFile`, so set the variable in your shell profile.

## If it does not appear

- **Cursor was not restarted** after the file changed.
- **The entry has a `command` instead of a `url`.** That is the stdio shape, which expects a
  process to launch. Reduck is a URL.
- **Authorization expired.** Cursor keeps a refresh token, and a long-idle one stops being
  accepted. The server then flips back to `needsAuth`, silently: authorize it again. If
  you are reading Cursor's own logs, this shows up as a `400` on the token endpoint rather than
  as anything mentioning Reduck.
