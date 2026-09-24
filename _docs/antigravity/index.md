---
title: Google Antigravity
description: Add Reduck to Google Antigravity by editing its MCP config file, then keep the connection signed in.
section: connect
order: 110
---

Antigravity has no list of ready-made connectors, so you add Reduck by editing a small config
file yourself. It takes a few more clicks than Claude Desktop. The steps below cover the whole
thing.

## Before you start

You need a Reduck account, and a paired browser if you want scripts to run in your own Chrome.
Both are in the [quick start](/docs/overview#quick-start).

## Add the server

Click the top-right corner menu icon (**…**), then select **MCP Servers**.

![Selecting MCP Servers from the Antigravity corner menu](mcp-servers-menu.png)

Click **Manage MCP Servers**.

![The Manage MCP Servers option](manage-mcp-servers.png)

Click **View raw config**.

![The View raw config button](view-raw-config.png)

Add the following to the file:

```json
{
  "mcpServers": {
    "reduck": {
      "serverUrl": "https://mcp.reduck.ai/"
    }
  }
}
```

Save the file and return to **MCP Servers** to confirm `reduck` is listed.

## Check that it worked

Open **MCP Servers** and check that `reduck` is signed in. If it is not, click **Authenticate**
and sign in to your Reduck account in the browser tab that opens.

![Antigravity showing an MCP authentication error](authentication-error.png)

> [!WARNING]
> **The connection drops often, and it is easy to miss.** When it drops, Antigravity answers using
> the normal Gemini agent instead of Reduck. You still get a reply, so the request looks like it
> worked even though Reduck never ran. Before trusting a result, check that `reduck` is still
> signed in under **MCP Servers**.
>
> The connection also drops whenever your internet or your session is interrupted, and it does not
> come back on its own — sign in again from **MCP Servers → Authenticate**. Both problems are
> being worked on.
