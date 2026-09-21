---
title: Browsers
description: Which browsers the Reduck extension runs on, how to set up a browser that is not Chrome, and which ones are not supported.
section: get-started
order: 35
---

Reduck runs scripts inside a browser you already use, through an extension. Chrome is the default,
and every Chromium browser works the same way with the same extension and the same setup.

## Supported

| Browser | Status | Setup |
| --- | --- | --- |
| Chrome | Supported | [Quick start](/docs/overview#quick-start) |
| Edge | Supported, verified | Same as Chrome |
| Brave | Supported, verified | Same as Chrome |
| Arc | Supported, verified | Same as Chrome, with [two quirks](#arc) |
| Other Chromium browsers | Expected to work | Same as Chrome |
| Firefox | **Not supported** | [Why](#firefox-and-safari) |
| Safari | **Not supported** | [Why](#firefox-and-safari) |

Reduck needs **Chromium 138 or later**. Any current release of the browsers above clears that.

## If you use Chrome, there is nothing on this page for you

Install the extension, pair the browser, done. The rest of this page is only for the other cases.

## Edge, Brave and other Chromium browsers

Nothing is different. The extension installs from the Chrome Web Store, pairs the same way, and
each browser becomes its own device. There are no browser-specific flags, policies or settings to
change.

Edge asks once for permission to install extensions from a store other than its own. Allow it, and
the Chrome Web Store listing installs normally.

> [!NOTE]
> Each browser you pair is a separate device with its own cookies and its own sessions. Being
> signed in to a site in Chrome does not sign you in on the Edge device. Pick the device that
> holds the session the script needs, or leave `deviceId` out and let Reduck choose.

## Arc

Arc works, and two things about it are worth knowing before you debug something that is not
broken:

- **Arc always uses your real profile.** It ignores `--user-data-dir`, so you cannot pair a
  throwaway profile for testing.
- **Arc hides the Chromium side panel.** The extension still works; only that one surface is not
  reachable through Arc's own UI.

Arc also reports itself as plain Chromium, so it is listed as **Chromium**, not as Arc. If you
pair several Chromium browsers, that is the one detail that will make you run a script on the
wrong one.

## Chrome on Linux

Supported, with one requirement: the browser must run **headful**, on a real desktop session or on
`Xvfb` plus a window manager.

```bash
Xvfb :99 &
export DISPLAY=:99
```

A `--headless` Chrome defeats the point of a paired browser. The reason scripts survive on sites
that block automation is that they run in an ordinary, visible browser carrying your own session.
Headless gives that up.

## Firefox and Safari

Not supported, and not a setup problem you can work around.

Reduck drives pages through `chrome.debugger` and the Chrome DevTools Protocol — that is how it
takes screenshots, prints PDFs, intercepts downloads and injects script before a page navigates.
**Neither Firefox nor Safari has an extension API equivalent to `chrome.debugger`.** Firefox's
remote debugging is not reachable from inside an extension, and Safari has nothing comparable at
all. Several smaller APIs Reduck depends on are Chromium-only as well.

Supporting either one means rewriting the automation engine against a different mechanism, not
porting the extension.

If you do not want to run a local browser at all, the [managed browser](/docs/core-concepts) does
not care which browser you use day to day.

## If a script fails on one browser only

Run the same script on a second paired browser before concluding the browser is the cause. Sites
block by IP and by account far more often than by browser, and a failure that reproduces
identically on two browsers is not a browser problem.
