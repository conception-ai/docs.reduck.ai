---
title: The CLI
description: Run saved scripts from a terminal — one at a time or twenty at once — and write each result to disk.
section: using-reduck
order: 220
---

The CLI runs scripts from a terminal and prints the result as JSON on stdout, which makes it the way
to feed a script's output into something else. It needs Node 22 or newer, and nothing to install.

```bash
npx @reduck-ai/cli@latest login
npx @reduck-ai/cli@latest run --script reduck/linkedin.com/search query="AI agents"
```

`login` opens your browser once and keeps the token. For a machine with no browser, set
`REDUCK_API_KEY` instead, with a key from [reduck.ai/api-keys](https://reduck.ai/api-keys).

## Learning the rest

`--help` is written for agents as much as for people, and it is the reference: running twenty
scripts at once, chaining them through one browser, sending a file, picking a device. Point your
agent at it rather than reading it yourself.

```bash
npx @reduck-ai/cli@latest --help
npx @reduck-ai/cli@latest run --help
```
