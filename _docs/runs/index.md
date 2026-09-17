---
title: Runs, batches and traces
description: Every script execution is a run with an id — how to read its result, its evidence, and what changes when you run several at once.
section: using-reduck
order: 280
---

One execution of one script on one browser is a **run**. It gets an id, and that id is how you
read back what happened — the result, or the error, or the step-by-step evidence.

Your agent does this for you, and the same runs are listed at
[reduck.ai/runs](https://reduck.ai/runs).

## What a run gives you

| You want                       | Ask for                     |
| ------------------------------ | --------------------------- |
| The result, or the error       | `read_run_results({runId})` |
| The steps, with screenshots    | `read_run_trace({runId})`   |
| Your recent runs, newest first | `list_runs`                 |

A result is the script's declared output — the JSON its schema promised. The trace is the evidence
behind it: what the browser did at each step, and what the page looked like. Reach for the trace
when a result is not what you expected.

## Running several at once

Passing a list of scripts instead of one runs them **at the same time, a browser each**, up to 20
in a single call. This is the way to fan out: one call rather than twenty.

They share nothing — no cookies, no page, no order — and one failing does not stop the others. You
get one outcome per script, in the order you passed them, and a **batch id** for the group.

```json
{
	"scripts": [
		{ "host": "linkedin.com", "slug": "get_post", "args": { "url": "…" } },
		{ "host": "linkedin.com", "slug": "get_profile_info", "args": { "username": "…" } }
	]
}
```

Each script's arguments belong to that script, never to the call around it.

## A run id and a batch id are different ids

They answer different questions, and one is never the other:

- `read_run_results({runId})` reports that **one** run, even when it belongs to a batch.
- `read_run_results({batchId})` reports **every** script in the batch at once.

A trace is always per run, because there is one browser per run.

## Chaining instead of fanning out

Sometimes the second script needs what the first one left behind — a login, a page already open.
The [CLI](/docs/cli)'s `--sequential` and the API's `sequential` chain the same list through **one**
browser, in order, so each script inherits the previous one's cookies, page and navigation. It
never inherits the previous one's result: outputs are not piped.

A chain stops at the first failure, and the scripts after it report that they never ran.

## `queued` means busy, not broken

Each script in a batch takes its own slot on the target's budget. Ask for more than the budget and
the extra ones queue and drain as slots free up. A run sitting in `queued` is waiting its turn, not
failing to reach a browser.
