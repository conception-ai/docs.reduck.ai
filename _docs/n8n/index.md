---
title: n8n
description: Give an n8n AI Agent the Reduck tools with an MCP Client Tool node, and run scripts from a workflow.
section: connect
order: 100
---

n8n reaches Reduck through its built-in **MCP Client Tool** node, attached to an AI Agent. The
agent then has the Reduck tools alongside everything else in the workflow.

## Before you start

You need a Reduck account, and a paired browser if you want scripts to run on your own Chrome.
Both are in the [quick start](/docs/overview#quick-start).

You also need an [API key](/docs/api-reference) from your Reduck dashboard. n8n runs on a server
with no browser to complete a sign-in flow, so the key is how a workflow authenticates.

## Add the node

1. Add an **AI Agent** node to your workflow.
2. On its **Tool** connector, add an **MCP Client Tool** node.
3. Fill it in:

| Field | Value |
| --- | --- |
| Endpoint URL | `https://mcp.reduck.ai` |
| Server Transport | **HTTP Streamable** |
| Authentication | **Header Auth** |
| Credential → Name | `X-API-Key` |
| Credential → Value | your Reduck API key |

**Server Transport** defaults to HTTP Streamable, which is what Reduck speaks. The other option,
Server Sent Events, is deprecated and will not connect.

## Raise the timeout

Under **Options → Timeout**, set something generous. **60000 ms is the node's default and it is
too low for Reduck**: `run_script` blocks while a real browser loads a real page, and a cold
device plus a slow site will cross a minute without anything being wrong.

Start at `300000` (five minutes) and lower it only if you know your scripts are fast.

This is the single most common reason a Reduck node fails in n8n while the same script succeeds
everywhere else.

## Narrow the tool list

Reduck exposes 30 tools, and most of them are for authoring scripts rather than running them. An
agent that only has to run the catalogue does better with fewer:

Set **Include Tools** to *Selected* and pick:

- `list_scripts` — find a script for the site
- `read_script` — read its arguments before calling it
- `run_script` — run it

Add `list_devices` if the workflow picks a browser explicitly, and `list_runs` or
`read_run_results` if it needs to inspect a run afterwards.

## Confirm it is connected

Open the MCP Client Tool node. Once the credential is accepted, the node lists the tools it found
on the server — that list is the proof. Then run the workflow once and ask the agent to call
`whoami`; it reports the Reduck account the key belongs to.

## If it does not appear

- **The transport is set to Server Sent Events.** It is deprecated and Reduck does not serve it.
  Switch to HTTP Streamable.
- **The header name is wrong.** It is `X-API-Key`, and Header Auth sends exactly what you type.
  Bearer Auth also works, with a token rather than an API key.
- **The node timed out.** See above — the default minute is not enough for a browser run.
- **The key is not valid.** An unrecognized key comes back as a `401`, which n8n surfaces as a
  failed connection rather than as an authentication message.

## Going the other way

This page is about n8n driving Reduck. A Reduck script can also call *into* n8n — a workflow's
`/webhook/<path>` is an ordinary URL, so a script reaches it with no session at all.
