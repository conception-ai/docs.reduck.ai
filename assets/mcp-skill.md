# Reduck

Reduck automates any website through reusable browser scripts, filling the gaps where no official API exists. A script is addressed as `[<handle>/]<host>/<slug>` — discover one with `list_scripts`, read its contract with `read_script`, run it with `run_script`.

## Where scripts run

Every script runs on a **device**: a browser paired to your account through the Reduck extension. The automation inherits that browser's state — the sites you're signed into, its fingerprint — so a script that needs a login usually just works, and credentials never leave your machine. Pair from the extension's side panel; `list_devices` shows what's paired.

You can pair several browsers, each with its own device id. `browser` picks _where_ a run happens: omit it for your paired browser, `"extension"`/`"local"` to auto-pick your single device of that kind, or `{deviceId}` (equivalently the `deviceId` shorthand) to pin one — auto-pick fails if 2+ match. `"managed"` runs on a Reduck managed browser and needs a privileged account; it also takes `region`/`country`. A managed run spends browser time, and `country` additionally spends residential-proxy bandwidth — `whoami` shows both against this period's quotas.

What to run is one object: `script: {host, slug, handle?, args?}` — a script's `args` live with that script, never at the top level of the call. Each `run_script` opens a **fresh** browser.

To run several scripts, pass `scripts` — a list of those same objects, each with its own `args`. They run **at the same time, one browser each**, so this is how to fan out: one call instead of N. They share nothing (no cookies, no DOM, no order) and one failing doesn't stop the others, so you get one outcome per entry in the order you passed them, plus a `batchId`. Each entry takes its own slot on the target's concurrency budget, so more scripts than slots just queue and drain — `queued` means busy, not offline.

A run id and a batch id are different ids, and each answers for exactly one thing: `read_run_results({runId})` always reports that ONE run (its result or error) even when it belongs to a batch, while `read_run_results({batchId})` reports every script in the batch at once. The step trace and its screenshots live behind `read_run_trace({runId})`.

## Owners

Any owner handle scopes `list_scripts` / `read_script` / `run_script`: `reduck` for the curated catalogue, `@user` (with @) for a user's scripts, `project` (without @) for a project's. Omit `handle` for your own.

To iterate on an existing script: `create_draft_script_version` creates a persisted draft; test it with `run_script({script: {version_id}})`, then `promote_script_version` to make it current. Use `list_script_versions` to see all versions (IDs, draft status, notes), and `delete_draft_script_version` to discard a draft you abandoned. To build or modify scripts, load the authoring doc from the index below.

## Available docs

Load with `read_docs({name})`.

- `authoring_scripts` — Build Reduck scripts — discover selectors live via exec_code, crystallize into saved scripts. Load before writing or modifying any script.
