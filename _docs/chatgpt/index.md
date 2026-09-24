---
title: ChatGPT
description: Add Reduck to ChatGPT on the web as a custom connector, so the agent can run browser scripts on the sites that have no API of their own.
section: connect
order: 50
---

ChatGPT reaches Reduck as a custom connector, added from settings on the web.

## Before you start

You need a Reduck account, and a paired browser if you want scripts to run on your own Chrome.
Both are in the [quick start](/docs/overview#quick-start).

## Add the connector

Open **Settings**, then work through to the connector list.

![ChatGPT settings](settings-1.png)

![The connector section of ChatGPT settings](settings-2.png)

![The connector list](settings-3.png)

On the right, click **＋ → Add connection**.

![The add connection control](add-connection.png)

Set the name to `Reduck` and the URL to `https://mcp.reduck.ai`, tick **I understand and want to
continue**, then click **Create**.

![The new connection form, with the name and URL filled in](connection-details.png)

## Confirm it is connected

Start a new session. Reduck is listed among the connectors available to it, and the first call
opens a browser to sign in to your Reduck account.

## Run your first script

Connecting the agent is not the last step of setup — a run is. Ask your agent to do something on a
website, and it searches the official library, picks the scripts it needs, and runs them for you.

```text
Use Reduck to fetch the latest X.com reposts by Reduck AI
```

Once it runs, finish setup at [reduck.ai/setup](https://reduck.ai/setup).

## If it does not appear

- The session predates the connector. A session already running does not pick one up — start a
  new one.
- The consent box was left unticked, so **Create** never completed.
- Sign-in never finished. The browser tab that opens on the first call has to be completed before
  any tool works.
