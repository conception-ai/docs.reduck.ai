---
title: Quick start
description: Create an account, pair your browser, and connect your agent to Reduck over MCP, the CLI or the API.
section: get-started
order: 20
---

Three steps: an account, a paired browser, and a way in for your agent.

## 1. Create an account

Sign up at [reduck.ai](https://reduck.ai/#signin). The free tier is enough to work through this
page.

## 2. Pair your browser

Install the [Reduck extension](https://chromewebstore.google.com/detail/reduck/koccidjchcojlmgkdhibpgjbnhcoopio)
from the Chrome Web Store, then click **Authorise** when it asks to pair with your account.

A paired browser is a [device](/docs/devices). Scripts run in it act as you: they inherit the sites
you are already signed into, and no password ever reaches Reduck. If you miss the prompt, you can
start pairing again from [the extension](/docs/extension) itself.

> The extension is only needed to run scripts on your own Chrome. If you plan to use managed
> browsers only, skip this step.

## 3. Connect your agent

:::tabs
::tab Reduck MCP (Recommended)

The MCP server lets an agent discover scripts, run them, and read back results on its own. It is
the way in most people want.

There is nothing to install: Reduck is a remote server at `https://mcp.reduck.ai`, and your client
signs in through your browser the first time it calls a tool. Pick your client:

::tiles-from connect-your-agent

::tab Reduck CLI

The CLI runs scripts from a terminal, in parallel, and writes each result to disk — which makes it
the way to feed a script's output into something else.

```bash
npx @reduck-ai/cli@latest login
```

Then run a script:

```bash
npx @reduck-ai/cli@latest run --script reduck/linkedin.com/search query="AI agents"
```

The `--help` output is written for agents as much as for people, so pointing your agent at it is
usually faster than reading it yourself:

```bash
npx @reduck-ai/cli@latest --help
npx @reduck-ai/cli@latest run --help
```

[The CLI](/docs/cli) covers the rest: running twenty scripts at once, chaining them, and sending a
file with a run.

::tab API

The REST API calls scripts over HTTP, with no MCP server and nothing to install. Use it when your
agent has an HTTP client but no sandbox, when you are running headless, or when you are wiring
Reduck into an orchestrator such as n8n.

Create a key at [reduck.ai/api-keys](https://reduck.ai/api-keys), then:

```bash
curl https://mcp.reduck.ai/run \
  --header "X-API-Key: $REDUCK_API_KEY" \
  --header "Content-Type: application/json" \
  --data '{"script":{"handle":"reduck","host":"airbnb.com","slug":"search","args":{"city":"Lisbon"}}}'
```

> The API runs scripts on [managed browsers](/docs/browsers) by default. A script that needs your
> own Chrome is easier to reach through MCP or the CLI.

The full endpoint list is in the [API reference](/docs/api-reference), the credential rules are in
[Authentication](/docs/authentication), and [the SDK](/docs/sdk) wraps the same API in TypeScript.
:::

## 4. Run something

Start a new session and ask for a task that lives on a website:

```
Using Reduck, find the top 3 posts on "AI agents" from LinkedIn this week,
then give me the profiles of people who look like B2B AI buyers.
```

Your agent will search the official library, pick the scripts it needs, and run them on your
paired browser.

> [!TIP]
> If a session starts badly — the agent guessing at a site instead of looking for a script — ask it
> to call Reduck's `read_docs` tool first. [MCP tools](/docs/mcp-tools) lists everything it can
> reach for.
