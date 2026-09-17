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
2. Install the [Reduck extension](https://chromewebstore.google.com/detail/reduck/koccidjchcojlmgkdhibpgjbnhcoopio) then click **Authorise** when it asks to pair with your account. If you miss the prompt, start pairing again from [the extension](/docs/extension).
3. Install Reduck MCP. Follow the right install step depending on your client:

    ::tiles-from connect-your-agent

4. Start a new session and get started with your first automation! You can try a prompt like:

    ```markdown
    Using Reduck MCP, search on Google the top 3 latest posts of the week on "AI Agents" on LinkedIn. Then return the profiles of potential buyers of B2B AI agents
    ```
