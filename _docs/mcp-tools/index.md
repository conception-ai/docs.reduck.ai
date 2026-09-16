---
title: MCP tools
description: Every tool the Reduck MCP server gives your agent — to find a script, run it, read the result, or write a new one.
section: using-reduck
order: 210
---

Once your agent is [connected](/docs/quick-start), Reduck appears to it as a set of tools. You
never call these yourself, but knowing what exists tells you what to ask for — and lets you name a
tool when the agent picks the wrong one.

The usual path is three tools deep: **find** a script, **read** its contract, **run** it.

## Finding and running

| Tool               | What it does                                                                                                      |
| ------------------ | ----------------------------------------------------------------------------------------------------------------- |
| `list_scripts`     | Search the scripts you can run: your own, your projects', and the official catalogue.                             |
| `read_script`      | One script's contract — arguments, output, whether it needs a login, whether it changes anything.                 |
| `run_script`       | Run it, on a [device](/docs/devices) or a [managed browser](/docs/browsers). One script, or up to twenty at once. |
| `list_runs`        | Your [runs](/docs/runs), newest first.                                                                            |
| `read_run_results` | What a run returned, by run id or batch id.                                                                       |
| `read_run_trace`   | The steps and screenshots behind a run.                                                                           |

## Your account

| Tool           | What it does                                                                                    |
| -------------- | ----------------------------------------------------------------------------------------------- |
| `whoami`       | Which account the agent is signed in as, its projects, and this period's [usage](/docs/quotas). |
| `list_devices` | The browsers paired to the account, and their ids.                                              |
| `read_docs`    | Reduck's own documentation, including the script-writing reference.                             |

## Writing scripts

These are the tools an agent uses when no saved script fits. [Writing scripts](/docs/writing-scripts)
covers what it does with them.

| Tool                                                          | What it does                                                                          |
| ------------------------------------------------------------- | ------------------------------------------------------------------------------------- |
| `start_session` / `stop_session`                              | Open a browser the agent keeps across calls, and close it.                            |
| `exec_code`                                                   | Drive that browser directly — the escape hatch used while working a flow out.         |
| `create_script`                                               | Save the result as a new script.                                                      |
| `create_draft_script_version`                                 | Open an editable draft of an existing script.                                         |
| `patch_draft_script_version`                                  | Edit that draft in place.                                                             |
| `promote_script_version`                                      | Make a draft the current version.                                                     |
| `delete_draft_script_version`                                 | Discard a draft.                                                                      |
| `list_script_versions`                                        | The line of [versions](/docs/script-versions), newest first.                          |
| `update_script_metadata`                                      | Name, description, visibility.                                                        |
| `archive_script` / `unarchive_script`                         | Take a script out of listings without deleting it, and put it back.                   |
| `read_host_readme` / `set_host_readme` / `delete_host_readme` | The notes shared by every script on one site. See [Host READMEs](/docs/host-readmes). |

> `run_script` opens its own browser, so a plain run needs no session. `start_session` is for
> `exec_code` — it is how an agent explores a site it is about to write a script for.

## Telling your agent what to use

Naming the tool works, and so does naming the script:

```
Use Reduck's list_scripts to find something for airbnb.com, then read_script before you run it.
```

If a session starts badly — the agent inventing selectors instead of looking for a script — asking
it to call `read_docs` first usually settles it.
