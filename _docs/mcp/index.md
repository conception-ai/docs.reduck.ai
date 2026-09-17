---
title: MCP
description: What your agent does with Reduck once it is connected — find a script, read its contract, run it — and how to steer it.
section: using-reduck
order: 210
---

Once your agent is [connected](/docs/overview#quick-start), Reduck appears to it as a set of tools.
You never call them yourself, but knowing the shape tells you what to ask for.

The usual path is three tools deep:

1. `list_scripts` finds a script for the task, across your own, your projects' and the official library.
2. `read_script` reads its contract: arguments, output, whether it needs a login.
3. `run_script` runs it, on your paired browser, one script or up to twenty at once.

Everything else the server offers, it describes itself at
[mcp.reduck.ai/skill](https://mcp.reduck.ai/skill), the same text your agent reads through
`read_docs`. That page, not this one, is the reference.

## Telling your agent what to use

Naming the tool works, and so does naming the script:

```
Use Reduck's list_scripts to find something for airbnb.com, then read_script before you run it.
```

> [!TIP]
> If a session starts badly — the agent guessing at a site instead of looking for a script — ask it
> to call `read_docs` first.

## Writing a script

When no saved script fits, your agent writes one. You do not write selectors; you ask, and it works
the site out in a live browser:

```
Use Reduck to create a script for trends.google.com keywords.
```

It opens a browser it keeps across calls, explores the site, saves the script with the input and
output schemas callers get, tests it, and iterates on a draft version until it holds. The script is
yours from then on: keep it private, move it to a [project](/docs/core-concepts#projects) for your
team, or make it public.
