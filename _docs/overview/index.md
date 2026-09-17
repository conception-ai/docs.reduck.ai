---
title: Overview
description: Create an account, pair your browser, connect your agent to Reduck MCP, and run your first automation.
section: get-started
order: 10
---

Agents struggle to automate websites with no API, such as LinkedIn, Reddit or your custom ERP. While they are able to do [Computer Use](https://claude.com/blog/dispatch-and-computer-use), aka manipulating a browser to click or type, it is inadequate for complex and heavy workloads as it is:

- **Unreliable**: results vary and get worse with context size explosion
- **Slow**: each step requires slow thinking to decide next browser action
- **Expensive**: context fills up quickly and complex tasks hit rate limits

That's why we built Reduck MCP: **the easiest way for an agent to integrate and automate any site you use**.

Reduck MCP allows agents to discover, run and create browser automation scripts that serve as tools. Scripts run in your own Chrome, through our extension, which allows your agent to work where you are logged in — no credentials exposure, and same fingerprints so no bot detection.

By exposing deterministic scripts as tools with a clear contract of inputs and outputs, Agents can perform complex automations quickly, accurately and cheaply, as they no longer need to manipulate a browser directly.

## Quick start

1. Create an account at [reduck.ai](https://reduck.ai/#signin).
2. Install the [Reduck extension](https://chromewebstore.google.com/detail/reduck/koccidjchcojlmgkdhibpgjbnhcoopio) and pair it with your account.

    :::details More about pairing
    Right after the install, the extension asks to pair with your Reduck account: click
    **Authorise**. A paired browser is a [device](/docs/core-concepts#browser), and scripts run in it act as
    you — they inherit the sites you are already signed into, and no password ever reaches
    Reduck.

    If you missed the prompt, start pairing again from the extension itself:

    ::video de9cf994bb67e90bdecc4e37a450bbb3 Restart pairing from the Reduck extension

    The extension is only needed to run scripts on your own Chrome. To use
    [managed browsers](/docs/core-concepts#browser) only, skip this step.
    :::

3. Install Reduck MCP. Follow the right install step depending on your client:

    ::tiles-from connect-your-agent

4. Start a new session and get started with your first automation! You can try a prompt like:

    ```markdown
    Using Reduck MCP, search on Google the top 3 latest posts of the week on "AI Agents" on LinkedIn. Then return the profiles of potential buyers of B2B AI agents
    ```

## Key Features

Reduck MCP possesses a unique blend of features that make it a first class tool for your Agent to automate complex web tasks:

- **[Official script library](/docs/core-concepts#official-scripts-library)**: get started in minutes with the official library of scripts we maintain
- **[Stealthy and private extension](/docs/core-concepts#browser)**: Reduck leverages your browser logged in state, fingerprints and residential IP so detection risk is minimal and credentials never leave your machine
- **[Parallel runs](/docs/core-concepts#parallel-runs)**: scripts can be run in parallel with a single tool call for fast iterations