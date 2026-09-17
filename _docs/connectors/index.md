---
title: Connectors
description: Lend one site's session to a managed browser, so a script that needs a login can run when your laptop is closed.
section: security
order: 320
---

A [managed browser](/docs/core-concepts#browser) starts with no session of yours. A **connector** is how you
give it one: the cookies you hold for a single site, uploaded from your own Chrome, so a script
that needs a login acts as you there.

It is the one case where a site's session leaves your machine, and it happens because you asked for
it, one site at a time.

## Adding one

From the Reduck extension's side panel, open **Manage connectors** and pick the site. The extension
reads the cookies that site set in the browser you are signed into, and uploads them.

What goes up is what the site would send back to itself: the cookies for the host, its subdomains,
and the parent domain an SSO login sets. Nothing from any other site.

Upload again for the same site to replace it — which is also the fix when a session expires.

## What a connector can do

- **One site.** A connector is bound to its host. A script for another site cannot read it.
- **Managed runs only.** Runs on your own Chrome already have your real session and never touch a
  connector.
- **A login, not an account.** It proves to that site that the session is yours. It is not a
  password, and it does not let Reduck sign in again once the site ends the session.

Stored connectors are sealed at rest under the app's own key — there is no key for you to keep, and
no page that shows the cookies back to you.

> [!WARNING]
> A connector lasts as long as the site lets the session last. Sites that rotate cookies often, or
> that pin a session to one IP, will end it sooner — sometimes within hours. A managed run that
> starts failing on a site you have a connector for usually needs a fresh upload, not a fix to the
> script.

## Removing one

Delete it at [reduck.ai/connectors](https://reduck.ai/connectors). The next managed run for that
site has no session again, and a script that needs one fails rather than acting as a stranger.

Signing out of the site in your own browser does not remove the connector — the copy Reduck holds
is separate. Delete it to be sure.

## When not to use one

If the work can run on your own Chrome, it should: no session leaves the machine, and there is
nothing to expire or to revoke. Connectors are for automation that has to run while your laptop is
closed. [Where credentials live](/docs/credentials) compares the two.
