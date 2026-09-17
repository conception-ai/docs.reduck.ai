---
title: Script versions
description: Every script is a line of versions — drafts you can edit and test, and promoted versions that never change.
section: using-reduck
order: 290
---

A script is not one body of code but a line of **versions**. A version is a snapshot of the code
together with the input and output schemas it was written against, and every run targets one.

That pairing is the point: an argument that worked last week works today, because the schema that
accepted it is part of the same snapshot as the code that read it.

## Draft, then promoted

A version is editable while it is a **draft**, and never again once it is promoted.

1. `create_draft_script_version` takes the script as it stands and opens a draft from it.
2. `patch_draft_script_version` edits that draft in place — no new version each time you fix a
   selector.
3. Run it by its `version_id` to test it. Nothing that calls the script by name is affected yet.
4. `promote_script_version` makes it the current version. From then on, that is what callers get.

A draft you abandon is discarded with `delete_draft_script_version`. `list_script_versions` shows
the line, newest first, with which one is current and which are still drafts.

## Running an old version

Both the MCP and the CLI take a version id in place of "whatever is current":

```bash
npx @reduck-ai/cli@latest run --script linkedin.com/get_post url=… --version-id <id>
npx @reduck-ai/cli@latest read linkedin.com/get_post --version-id <id> --code
```

Useful for checking whether a site changed or a script did.

> A version id addresses one script's snapshot. It replaces the version, not the script — the host
> and slug still say which script you mean.
