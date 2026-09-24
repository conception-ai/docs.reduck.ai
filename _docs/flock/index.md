---
title: Flock apps
description: Deploy a folder as a hosted page that runs Reduck scripts as whoever opens it, so the person using an app pays for the work it does.
section: integrations
order: 260
draft: true
---

> [!IMPORTANT]
> Flock is in early access, and enabled per account. Its CLI commands are hidden from `--help`
> unless `REDUCK_EXPERIMENTAL=1` is set, and answer `403` on an account without it. Ask at
> [form.reduck.ai](https://form.reduck.ai).

A **flock app** is one folder — a page, a database, and server-side tasks — deployed with one
command and hosted by Reduck. It exists because a script that returns JSON is not yet something you
can hand to a colleague: an app is the surface around it.

The page runs Reduck scripts and calls a model with no key of its own. Whoever opens it signs in to
Reduck, and their own credential is what the calls are made with — so the person using the app pays
for the app's work, not the person who deployed it.

## The shape of one

Four files, and a fifth the CLI writes:

| File                         | What it is                                                                               |
| ---------------------------- | ---------------------------------------------------------------------------------------- |
| `manifest.json`              | Identity, the settings an install asks for, the secrets it needs, the hosts it may reach |
| `migrations/001-initial.sql` | The whole schema, run in name order against an empty database                            |
| `front.jsx`                  | The whole page. React is usual, not required                                             |
| `tools.json`                 | The tasks the app offers an agent                                                        |
| `flock.json`                 | Written by the CLI — this machine's pointer to the installed app. Not yours to edit      |

## Deploying

```bash
npx @reduck-ai/cli@latest flock init ./my-app && cd my-app
npx @reduck-ai/cli@latest flock deploy                       # builds an image
npx @reduck-ai/cli@latest flock install @you/my-app --dir .   # mints the running app
npx @reduck-ai/cli@latest flock open
```

Two steps, in that order, and they are different things. `deploy` ships an **image** — an artefact,
with nothing running. `install` mints an **app** from it: one running copy with a database of its
own. Deploying alone leaves you with nothing to open.

## Operating one

```bash
npx @reduck-ai/cli@latest flock sql "SELECT * FROM answers LIMIT 5"
npx @reduck-ai/cli@latest flock db                 # tables, rows, size
npx @reduck-ai/cli@latest flock files              # the app's blobs
npx @reduck-ai/cli@latest flock config:set brand.domain=reduck.ai
npx @reduck-ai/cli@latest flock access authenticated
npx @reduck-ai/cli@latest flock releases           # …and rollback <n>
```

`sql` and `files` go through the same doors the page uses, so what you read is what the page sees.

## The full guide

This page is an orientation. The reference — the SDK the page is built against, tasks and crons,
secrets, and how an app is judged — is what the CLI prints:

```bash
npx @reduck-ai/cli@latest flock docs
npx @reduck-ai/cli@latest flock --help
```
