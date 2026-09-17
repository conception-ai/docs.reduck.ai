---
title: Quotas and limits
description: What a run spends, what stops one, and the levers that get you moving again.
section: using-reduck
order: 250
---

Three counters run against your plan, and they reset at the end of each billing period. Ask your
agent for `whoami` to see all three at once, with the date they reset.

| Counter                         | Spent by                                   | If you hit it                                      |
| ------------------------------- | ------------------------------------------ | -------------------------------------------------- |
| **Monthly script runs**         | Every run, on any browser                  | A bigger plan is the only lever.                   |
| **Cloud browser time**          | [Managed](/docs/core-concepts#browser) runs, per minute | Run on your paired browser instead.                |
| **Residential proxy bandwidth** | Managed runs that set a `country`          | Drop the `country` and egress from the datacenter. |

A run on your own Chrome spends nothing but the run count: the browser is yours, and the traffic is
your connection.

A run refused for quota answers with the counter that stopped it, what it had spent, and when the
period resets — so your agent can tell you which of the three is the problem rather than that
"something failed".

## Where the limits are

Two limits are about one call rather than about your plan:

- **20 scripts per call.** A [batch](/docs/runs) can hold up to twenty; past that, make a second
  call.
- **Concurrency slots.** Each script in a batch takes a slot on the target. Asking for more than
  are free is fine — the rest queue and drain. `queued` means waiting, not offline.

## Timeouts

A script gets 30 seconds per action by default: a click, a wait for an element, anything that has
to happen on the page. Navigation has a budget of its own, which matters on heavy single-page sites
where the page is usable long before it stops loading.

Both are set inside the script, so a site that needs longer gets it there rather than from a
setting on your account.

## Managed browsers

Managed runs are entitled per account, not just metered. Where an account does not have them, the
option is absent from what the agent is offered rather than failing at the moment of the run —
so an agent cannot spend cloud browser time you did not agree to. The REST API is the door built
for managed runs; see [Browsers](/docs/core-concepts#browser).
