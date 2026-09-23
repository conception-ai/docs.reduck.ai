---
title: Supported browsers
description: Which browsers the Reduck extension runs on, how to set up a browser that is not Chrome, and which ones are not supported.
section: get-started
order: 35
---

Reduck supports the different Chromium browsers: Arc, Brave, Chrome and Microsoft Edge. With
Chrome, just [install the extension](https://reduck.ai/setup/install-extension?redirect_to=%2Fprojects).
The other Chromium browsers each have one detail of their own below. If you would rather not keep
a browser open at all, you want the [managed browser](/docs/core-concepts#browser) instead.

Reduck needs **Chromium 138 or later**, which any current release clears. [Firefox](#firefox),
[Safari](#safari) and [Opera](#opera) are not supported.

<a class="btn medium btn-primary" href="https://reduck.ai/setup/install-extension?redirect_to=%2Fprojects">Install the Reduck extension</a>

## Microsoft Edge

Edge asks for permission the first time you install an extension from a store other than its own.
Allow it, and the Chrome Web Store listing installs normally. Nothing else differs from Chrome.

## Brave

Brave blocks Google's push messaging by default, and push is how the server wakes your browser for
a run. **Turn it on before you pair, or the extension reports Session Active but no run ever starts.**

1. Open `brave://settings/privacy`.
2. Turn on **Use Google services for push messaging**.
3. Restart Brave.
4. Open the Reduck extension side panel and pair the browser.

> [!WARNING]
> A paired Brave that looks healthy but answers no run at all is almost always this setting.

## Chrome on Linux

Supported, but the browser must run **headful**, on a real desktop session or on `Xvfb` plus a
window manager. Headless gives up the ordinary, visible browser that lets scripts survive sites
that block automation.

```bash
Xvfb :99 &
export DISPLAY=:99
```

## Arc

Arc has no side panel, which is where pairing happens, so the only way to pair a device is to
reinstall the extension: remove it, install it again, and pair from the prompt that follows.

Arc also reports itself as plain Chromium, so it is listed as **Chromium**, not as Arc. If you
pair several Chromium browsers, that is the one detail that will make you run a script on the
wrong one.

## <span id="firefox-and-safari"></span><span id="firefox"></span><span id="safari"></span><span id="opera"></span>Firefox, Safari and Opera

Not supported, and not a setup problem you can work around.

Firefox and Safari rely on extension APIs that Chromium has and they do not, so supporting them
takes more than porting the extension. It is on the roadmap, but not planned in the short term.

Opera is Chromium-based, but it is not one of the browsers we support or test today. The extension
is not validated there, so pairing it is not something we can back yet.
