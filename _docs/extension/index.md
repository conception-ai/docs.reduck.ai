---
title: The Reduck extension
description: Pair your own Chrome with your Reduck account, upload a site's cookies, and unpair when you are done.
section: get-started
order: 30
---

The extension is what makes your own Chrome available to Reduck. Install it once, pair it, and your
agent can run scripts in the browser you are already signed into.

Get it from the
[Chrome Web Store](https://chromewebstore.google.com/detail/reduck/koccidjchcojlmgkdhibpgjbnhcoopio),
then open its side panel from the toolbar.

> The extension is only needed for runs on your own Chrome. [Managed browsers](/docs/core-concepts#browser) need
> nothing installed.

## Pairing

Two ways, and they end in the same place — a [device](/docs/devices) on your account:

- **Pair from website** — the side panel sends you to Reduck, you approve, and the browser is
  paired. This is the one to use.
- **Pair manually** — the panel shows a code to type on the website. Use it when the first way
  cannot complete, such as in a profile where the redirect does not land.

Pair each Chrome profile you want to automate. Each becomes a device with its own id.

## What it can see

The extension drives the browser it is installed in, over Chrome's own automation protocol. It
reads the pages a script visits while that script runs, and sends back what the script declared as
its output.

It does not read your browsing outside a run, and no password reaches Reduck: the script reuses the
session your browser already holds.

## Connectors

**Manage connectors** uploads the cookies you hold for one site, so a
[managed browser](/docs/core-concepts#browser) can act as you there. That is the only way a site's session
leaves your machine, it is one site at a time, and it happens because you asked for it.

[Connectors](/docs/connectors) covers what is stored and how it is protected.

## Resetting a device

**Reset device** unpairs this browser. Runs aimed at it stop working, and pairing again gives you a
new device id. Use it when you are handing the machine on, or when you want the pairing to start
clean.
