---
title: The CLI
description: Run saved scripts from a terminal — one at a time, twenty at once, or chained through one browser.
section: using-reduck
order: 220
---

The CLI runs scripts from a terminal and prints the result as JSON on stdout, which makes it the
way to feed a script's output into something else. It needs Node 22 or newer, and nothing to
install:

```bash
npx @reduck-ai/cli@latest login
npx @reduck-ai/cli@latest run --script linkedin.com/get_profile_info username=dhuynh95
```

> `--help` is written for agents as much as for people. Pointing your agent at
> `npx @reduck-ai/cli@latest run --help` is usually faster than reading this page.

## Signing in

`login` runs an OAuth2 PKCE flow in your browser and stores the result in
`~/.config/reduck/config.json`, readable only by you. Tokens refresh on their own; `logout` clears
them.

For a machine with no browser, set `REDUCK_API_KEY` instead and skip `login` — create the key at
[reduck.ai/api-keys](https://reduck.ai/api-keys). `whoami` says which account you are on either way.

## Finding a script

```bash
npx @reduck-ai/cli@latest list                          # across your own, your projects, the catalogue
npx @reduck-ai/cli@latest list -q linkedin              # ranked search
npx @reduck-ai/cli@latest list reduck --host airbnb.com # one owner, one site
npx @reduck-ai/cli@latest read reduck/linkedin.com/get_post --code
```

`read` prints the contract — what the script takes, what it returns, whether it needs a login — so
it tells you the argument names `run` expects. `--code` adds the body.

## Running one

```bash
npx @reduck-ai/cli@latest run --script <address> key=value key=value
```

The address is `[<handle>/]<host>/<slug>`: bare for your own script, prefixed for someone else's
public one. Values are coerced to the type the schema asks for — `siret=913…` stays a string, and
arrays or objects are passed as JSON (`ids=[1,2]`).

| Option              | What it does                                                           |
| ------------------- | ---------------------------------------------------------------------- |
| `--script <addr…>`  | The script and its arguments. Repeat it to run several.                |
| `--device <id>`     | Run on one named [device](/docs/core-concepts#browser) instead of auto-picking.      |
| `--version-id <id>` | Run one [version](/docs/core-concepts#scripts) instead of the current one.   |
| `--out <dir>`       | Where downloaded files land (default `~/Downloads`).                   |
| `--sequential`      | Chain the scripts through one browser instead of running them at once. |

## Running several

Repeat `--script` and each one runs on its own browser, at the same time. stdout is then a JSON
array, one entry per script, in the order you gave them — and one failing does not stop the others.

```bash
npx @reduck-ai/cli@latest run --script site.com/a --script site.com/b
```

Add `--sequential` to chain them through a single browser instead: in order, each seeing the
previous one's cookies and page, stopping at the first failure.

```bash
npx @reduck-ai/cli@latest run --sequential --script site.com/login --script site.com/scrape max=5
```

The exit code is 0 only when every script succeeded, so a shell can test it.

## Sending a file

A script that declares a file input takes a local path:

```bash
npx @reduck-ai/cli@latest run --script jobs.com/apply file:resume.pdf=./cv.pdf
```

The CLI uploads the bytes with the run, so this works on your own browser and on a managed browser
alike.

## Reading the docs your agent reads

```bash
npx @reduck-ai/cli@latest skill                    # the index
npx @reduck-ai/cli@latest skill authoring_scripts  # the script-writing reference
```

No login needed. It is the same text the MCP serves through `read_docs`.

## Environment

| Variable              | What it does                                                                         |
| --------------------- | ------------------------------------------------------------------------------------ |
| `REDUCK_API_KEY`      | Sign in with a key instead of `login`.                                               |
| `REDUCK_MCP_URL`      | Point the CLI at another Reduck — a staging or local server. Log in once per target. |
| `REDUCK_EXPERIMENTAL` | Show early-access commands in `--help`.                                              |

Early-access commands work only on accounts enabled for them, and answer `403` otherwise. Ask at
[form.reduck.ai](https://form.reduck.ai) or [contact@reduck.ai](mailto:contact@reduck.ai).

## Trouble

The step trace is not printed with the result — read it through the MCP's `read_run_trace({runId})`,
or at [reduck.ai/runs](https://reduck.ai/runs). Bugs go to
[Discord](https://discord.com/invite/MPBQWCVTAq).
