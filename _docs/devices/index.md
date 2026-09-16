---
title: Devices
description: Every browser you pair with Reduck is a device — how to pair several, and how to pick which one a script runs on.
section: core-concepts
order: 150
---

A **device** is one browser paired to your account. It is what "bring your own browser" means in
practice: a script targeted at a device runs there, with the sites that browser is signed into and
the fingerprint it already has.

Pairing assigns the browser its own id — a UUID for that browser, not for the extension, which
every install shares. You can see your devices at
[reduck.ai/devices](https://reduck.ai/devices), or ask your agent for `list_devices`.

## Two kinds

| Kind        | What it is                                                                              |
| ----------- | --------------------------------------------------------------------------------------- |
| `extension` | A Chrome window paired through the [Reduck extension](/docs/extension). The one to use. |
| `local`     | A browser paired from a terminal with the CLI.                                          |

The kind only says how Reduck reaches the browser. A script does not know the difference.

## Pairing several browsers

Nothing stops you pairing a laptop and a desktop, or two Chrome profiles. Each is a device of its
own with its own id, so a script can be aimed at the machine that holds the right session.

## Picking one for a run

When your agent runs a script it can name a target:

| Target              | What happens                                                        |
| ------------------- | ------------------------------------------------------------------- |
| _omitted_           | Your paired browser is picked for you.                              |
| `"extension"`       | Your extension device is picked — as long as exactly one is paired. |
| `"local"`           | The same, for a CLI device.                                         |
| `{"deviceId": "…"}` | That one device, whichever kind it is.                              |
| `"managed"`         | No device at all: a [managed browser](/docs/browsers).              |

`"extension"` and `"local"` fail when two or more devices match, because there is no right answer
to pick between them. Name a `deviceId` when you have several.

> An extension device does not have to be awake. Reduck wakes it when a run targets it, so a
> browser listed as offline still runs the script — as long as Chrome is running.

## When a device is gone

Resetting a device from the extension unpairs it. Its id stops answering, and runs aimed at it
fail rather than being sent somewhere else. Pair again to get a new one.
