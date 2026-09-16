---
title: The official library
description: Scripts Reduck maintains for the most common websites, ready for your agent to use.
section: core-concepts
order: 120
---

Reduck's team maintains an official library of scripts for the most common websites — LinkedIn,
Airbnb, Instagram and many others — which you can browse at
[reduck.ai/explore](https://reduck.ai/explore).

Your agent knows how to discover and use these scripts through the MCP, so you do not need to name
one yourself. Asking for the outcome is enough; finding the script is the agent's job.

Scripts in the library are maintained against the real sites, so when a page changes underneath
one, fixing it is Reduck's work rather than yours.

## Naming one yourself

The library is owned by the handle `reduck`, so its scripts are addressed with that prefix:

```bash
npx @reduck-ai/cli@latest list reduck --host linkedin.com
npx @reduck-ai/cli@latest read reduck/linkedin.com/get_post
```

Over MCP the same scope is `handle: "official"`, which your agent uses when you ask it to stay with
maintained scripts rather than search everything you can reach.
