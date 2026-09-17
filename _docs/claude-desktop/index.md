---
title: Claude Desktop and web
description: Add Reduck to Claude Desktop or claude.ai as a custom connector.
section: connect
order: 20
---

Claude Desktop and Claude on the web share one set of connectors, so adding Reduck once covers
both. The connector follows your Claude account, not the machine.

## Before you start

You need a Reduck account, and a paired browser if you want scripts to run on your own Chrome.
Both are in the [quick start](/docs/overview#quick-start).

## Add the connector

Open **Settings → Connectors**, then **Manage connectors**.

![The connectors list in Claude settings](manage-connectors.png)

Open **＋ → Add custom connector**.

![The add custom connector menu](add-custom-connector.png)

Set the name to `reduck` and the URL to `https://mcp.reduck.ai`, then save.

![The custom connector form, with the name and URL filled in](connector-details.png)

Restart Claude Desktop. Claude on the web picks the connector up on the next page load.

## Confirm it is connected

Start a new chat and open the tools menu. Reduck is listed, and the first call opens a browser to
sign in to your Reduck account.

## If it does not appear

- Claude Desktop was not restarted. A running app does not pick up a new connector.
- The URL carries a path or a trailing segment. It is `https://mcp.reduck.ai` and nothing more.
- Sign-in never finished. The browser tab that opens on the first call has to be completed before
  any tool works.
