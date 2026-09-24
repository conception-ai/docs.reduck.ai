---
title: Quickstart
description: Reduck MCP gives your agent reusable browser scripts for the sites that have no API, such as LinkedIn or Gmail. They run in your own Chrome.
section: get-started
order: 10
---

![One integration, every website](one-integration-every-website.png)

Agents struggle to automate websites with no API, such as LinkedIn, Reddit or your custom ERP. While they are able to do [Computer Use](https://claude.com/blog/dispatch-and-computer-use), aka manipulating a browser to click or type, it is inadequate for complex and heavy workloads as it is:

- **Unreliable**: results vary and get worse with context size explosion
- **Slow**: each step requires slow thinking to decide next browser action
- **Expensive**: context fills up quickly and complex tasks hit rate limits

That's why we built Reduck MCP: **the easiest way for an agent to integrate and automate any site you use**.

Reduck MCP allows agents to discover, run and create browser automation scripts that serve as tools. Scripts run in your own Chrome, through our extension, which allows your agent to work where you are logged in — no credentials exposure, and same fingerprints so no bot detection.

By exposing deterministic scripts as tools with a clear contract of inputs and outputs, Agents can perform complex automations quickly, accurately and cheaply, as they no longer need to manipulate a browser directly.

## Quick start

1. Create an account at [reduck.ai](https://reduck.ai/#signin).
2. Install the [Reduck extension](https://chromewebstore.google.com/detail/reduck/koccidjchcojlmgkdhibpgjbnhcoopio) and pair it with your account. Not using Chrome? See [Supported browsers](/docs/supported-browsers).

    :::details More about pairing
    Right after the install, the extension asks to pair with your Reduck account: click
    **Authorise**.

    If you missed the prompt, start pairing again from the extension itself:

    ::video de9cf994bb67e90bdecc4e37a450bbb3 Restart pairing from the Reduck extension
    :::

3. Install Reduck MCP. Follow the right install step depending on your client:

    :::tabs
    ::tab Claude Code

    ```bash
    claude mcp add reduck --transport http --scope user https://mcp.reduck.ai
    ```

    ::tab Codex

    ```bash
    codex mcp add reduck --url https://mcp.reduck.ai
    ```

    ::tab Other clients

    ::tiles-from connect-your-agent
    :::

4. Start a new session and get started with your first automation! You can try a prompt like:

    ```markdown
    Using Reduck MCP, search on Google the top 3 latest posts of the week on "AI Agents" on LinkedIn. Then return the profiles of potential buyers of B2B AI agents
    ```

## Key Features

Reduck MCP possesses a unique blend of features that make it a first class tool for your Agent to automate complex web tasks:

- **[Official script library](/docs/core-concepts#official-scripts-library)**: get started in minutes with the official library of scripts we maintain — your agent finds them by calling `list_scripts` with the handle `"reduck"`
- **[Stealthy and private extension](/docs/core-concepts#browser)**: Reduck leverages your browser logged in state, fingerprints and residential IP so detection risk is minimal and credentials never leave your machine
- **[Parallel runs](/docs/core-concepts#parallel-runs)**: scripts can be run in parallel with a single tool call for fast iterations

## Build your own integrations

![An agent building a Reduck script from a prompt](how-it-works.gif)

If our Official Script Library does not contain the exact scripts you want (e.g. you need to automate a local government portal or a custom made ERP), then you can use Reduck MCP to build your own scripts for your agent to use:

- Provide a prompt to tell your Agent to build a new script, such as:

```markdown
"Use Reduck MCP to create a script that pulls IMDb's US box office top 10 for the weekend, with each film's IMDb rating, vote count, genre and Metascore"
```

- Once done your scripts can be discovered by your agent with Reduck MCP and can be found at [https://reduck.ai/projects/](https://reduck.ai/projects/)

## Integrations

Our browser automation infrastructure is mainly called from AI Agents through MCP but we also support CLI and REST API for alternative deployment options, e.g. inside an orchestrator such as n8n or a cron.

| Integration                     | Best for                                                                                                                                            |
| ------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------- |
| [MCP](/docs/connect-your-agent) | Agentic usage. Works on most clients, including mobile ones like Claude. Fast setup, nothing to install.                                            |
| [CLI](/docs/cli)                | Agentic usage from a terminal. Pipes outputs into complex workflows: store results locally, chain with other tools, run twenty scripts in parallel. |
| [REST API](/docs/api-reference) | Deployments without an agent: your own code, a cron, an orchestrator such as n8n. The door built for managed browsers, so it runs 24/7 without you. |
