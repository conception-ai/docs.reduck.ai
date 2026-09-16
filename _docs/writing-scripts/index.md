---
title: Writing scripts
description: What your agent does when the library has nothing for your site — and what makes the script it writes worth keeping.
section: using-reduck
order: 240
---

When no saved script fits, your agent writes one. You do not write selectors; you ask, and it works
the site out in a live browser:

```
Use Reduck to create a script for trends.google.com keywords.
```

This page is about what it does with that, and how to judge the result. The full reference the
agent reads is one command away — `npx @reduck-ai/cli@latest skill authoring_scripts` — and it
loads the same text through `read_docs`.

## How it goes

1. **Open a session.** `start_session` gives the agent a browser it keeps across calls, unlike a run
   which opens and closes its own.
2. **Explore.** With `exec_code` it navigates, looks at the page, and finds what it can rely on.
   Most of the work is here.
3. **Save.** `create_script` stores the body together with the input and output JSON Schemas — the
   contract callers get.
4. **Test.** It runs the saved script for real and compares the result against the trace.
5. **Iterate.** Fixes go into a [draft version](/docs/script-versions), tested by id, promoted when
   they hold.

## What makes a good script

**One affordance of the site, not one of your projects.** A script names something the site can
do: send a message, list slots, search. `find_pain_points` is a research project, and Reddit has no
button for it. Sort, filter, date range and pagination are _arguments_ to a script, not scripts of
their own — so your agent composes them, and the catalogue stays finite.

**Arguments a caller can type from memory.** A city, a query, a profile handle. Never an internal
token you could only get by driving the UI by hand.

**Output that mirrors the page, absence included.** A book with no spec table, a listing with no
price, a page a country blocks — those are answers, not failures, and the schema keeps them as
`null` rather than dropping the record.

**Anchors that outlast a redesign.** A script reads what the site's own code depends on — its
hydration state, its Schema.org markup, its accessibility roles, its URLs — rather than class names
and button text. Visible labels are the worst of the lot: `text="Connexions"` works in a French
Chrome and breaks in an English one, without saying why.

**Loud failure.** A script that catches its own errors and returns nothing is worse than one that
crashes: the crash names the line where the assumption was wrong. If a script has to recover from
its own actions, the fix belongs where it started, not in a retry.

## What you can do

- **Ask for the trace, not the result**, when something looks off. [The trace](/docs/runs) shows the
  steps and the screenshots behind the number that surprised you.
- **Write down what the site does to you** — a rate limit, a login that expires, a page that lies to
  signed-out visitors — as a [host README](/docs/host-readmes). Every script on that site gets it,
  and so does the next agent that touches one.
- **Run it twice, on different days.** A script passes in the session it was built in and fails on
  the second run more often than any other way. A second run in a clean browser is the real test.
- **Keep it private or share it.** A new script is yours; move it to a [project](/docs/projects) for
  your team, or make it public for everyone. See [Scripts](/docs/scripts).
