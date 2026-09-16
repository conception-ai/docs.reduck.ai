---
title: Scripts
description: The core unit on Reduck — deterministic code that automates one flow on one browser.
section: core-concepts
order: 110
---

The core unit on Reduck is a **script**: deterministic code that automates a flow on a browser.

A script can be **discovered** through the [official library](/docs/official-library), **run** with
MCP or the API, and **built** with MCP when the library has nothing for the site you need.

## How a script is addressed

`[<handle>/]<host>/<slug>` — the owner, the site, and the flow:

| Address                        | Whose                                                      |
| ------------------------------ | ---------------------------------------------------------- |
| `linkedin.com/get_post`        | Yours                                                      |
| `reduck/linkedin.com/get_post` | The [official library](/docs/official-library)             |
| `my-team/crm.internal/export`  | A [project](/docs/projects)'s — a bare handle is a project |
| `@someone/site.com/search`     | A person's public script — the `@` is what says so         |

The same three parts appear as `{ handle, host, slug }` wherever a script is passed as an object.

## Versions

A script is a line of versions, not a single body of code, and each one pins the code to the
schemas it was written against. Drafts are editable and promoted versions are not; see
[Script versions](/docs/script-versions).

## Visibility

Reduck offers two visibility levels for scripts.

- **Public scripts** can be discovered by the Reduck community, and may eventually be featured in
  the official scripts library.
- **Private scripts** remain yours alone. To share one with your team, assign it to a
  [project](/docs/projects) and grant your team access to that project.

## Building your own

Your agent will first try to do what you asked with scripts that already exist. When none fits —
a local government portal, a custom ERP — you can ask it to write one:

```
Use Reduck MCP to create scripts for trends.google.com keywords.
```

The scripts it writes are discoverable by your agent from then on, and appear under
[your project](https://reduck.ai/projects/create). [Writing scripts](/docs/writing-scripts) covers
what the agent does, and what makes the result worth keeping.

## Archiving

Archiving takes a script out of listings and out of reach of a run, without destroying it or its
history. It is reversible, and it is the right move for a script a site has outgrown — a deleted
script takes its runs' meaning with it.
