---
title: Browsers
description: Bring your own browser, or run on a Reduck-hosted managed browser — and when to use which.
section: core-concepts
order: 140
---

Reduck runs scripts in two modes.

## Bring your own browser

The default. Automation happens in your browser through the Reduck extension, so it inherits your
browser state automatically: which sites you are signed into, your browser fingerprint, and
everything else that makes the session look like you.

It requires your browser to be open. Each browser you pair is a [device](/docs/devices), and a run
can name which one it wants.

## Managed browser

Automation happens on Reduck's hosted cloud, so it can run 24/7 without your browser being
reachable, and scales past what one machine can do. Managed browsers are billed differently — and
more — than bringing your own; see the [pricing page](https://reduck.ai/pricing).

A managed browser starts with no session of yours, so a script that needs a login either signs
itself in, or uses a [connector](/docs/connectors) — the cookies for one site, uploaded from your
own Chrome.

Two knobs apply to managed runs only:

| Knob      | What it does                                                                                                                                                                            |
| --------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `region`  | Where the browser runs: Europe (Frankfurt), US East, US West, or Asia Pacific (Singapore). Pick the one nearest the site.                                                               |
| `country` | An ISO country code, such as `FR`. Routes the session through a residential proxy in that country — the lever for a geo-gated site. Omit it and the traffic leaves from the datacenter. |

`country` spends residential proxy bandwidth on top of browser time. [Quotas](/docs/quotas) covers
what each one costs you.

> [!NOTE]
> Managed runs are enabled per account. The [REST API](/docs/api-reference) is the door built for
> them; over MCP, an account without the entitlement is not offered the option at all.

## When to use which

|              | Bring your own browser                   | Managed browser                                |
| ------------ | ---------------------------------------- | ---------------------------------------------- |
| Volume       | Under ~100 script runs per hour          | Deployment at scale                            |
| Cost         | Cheaper                                  | More expensive                                 |
| Credentials  | Never leave your browser                 | Script signs itself in, or a connector         |
| Availability | Needs your browser open                  | 24/7                                           |
| Network      | Your connection                          | Datacenter, or a residential proxy per country |
| Files        | A path on the machine, or uploaded bytes | Uploaded bytes only                            |
