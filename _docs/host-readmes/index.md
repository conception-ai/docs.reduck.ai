---
title: Host READMEs
description: Notes an owner attaches to a website, shared by every script that targets it.
section: core-concepts
order: 180
---

Some things are true of a site rather than of one script on it: which account to use, a rate limit
worth respecting, a page that answers differently when signed out, a URL shape nothing else
explains.

A **host README** is where that goes. It is attached to a host — `linkedin.com`, not
`linkedin.com/get_post` — and every script targeting that host shares it.

## What it is for

Your agent reads it before it writes or debugs a script for that site, so a warning written once is
not learned again by every script that follows. It is the place for:

- the login the site expects, and how a script should obtain one
- a limit that will get an account blocked if a script ignores it
- the difference between what the page shows a visitor and what it shows you
- anything a selector cannot say

## Reading and writing one

| Tool                 | What it does         |
| -------------------- | -------------------- |
| `read_host_readme`   | The notes for a host |
| `set_host_readme`    | Replace them         |
| `delete_host_readme` | Remove them          |

Writing one needs edit access to the owner's scripts, so a project's README is a decision for the
team that owns the project. Deleting is idempotent: it succeeds even when there was nothing there.
