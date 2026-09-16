---
title: Where credentials live
description: What Reduck can and cannot see when a script acts as you.
section: security
order: 310
---

The short answer: when a script runs on your own Chrome, Reduck never sees your credentials at
all.

## On your own browser

The script drives the browser you are already signed into. It reuses the session your browser
already holds, so there is no password to send and none to store. Reduck receives the script's
declared output — and nothing else from the page.

## On a managed browser

A managed run has no session of yours to inherit, so it either logs itself in with credentials you
supply for that purpose, or uses a **connector**: the cookies for one site, uploaded from your own
Chrome by the extension and sealed at rest under the app's key.

A connector is scoped to a single site. A script for one site cannot read the connector for
another. [Connectors](/docs/connectors) covers how one is made, how long it lasts, and how to
remove it.

## What signs you in to Reduck

Different question, different answer: the API key or OAuth token your agent uses to reach Reduck at
all is never what a script uses to sign into a website. See
[Authentication](/docs/authentication).
