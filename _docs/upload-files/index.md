---
title: Upload files
description: Reduck MCP / CLI can send bytes to scripts to perform uploads, e.g. sending email with attachment, uploading an invoice, etc.
section: get-started
order: 30
---

Some scripts can upload a file, such as sending an email with attachment, uploading a CV for a job form, or an invoice for a portal.

Uploading files with scripts has different modus operandi, whether we run the script from MCP, the [CLI](/docs/cli) or the [REST API](/docs/api-reference).

We will see how it works with an example with the [`reduck/mail.google.com/send_email`](https://reduck.ai/explore/scripts/reduck/mail.google.com/send_email), from the official library.

## From your agent (MCP)

An agent cannot upload a file cheaply: it would have to write every byte as text. So it **names** a
file that is already on your machine, and your Chrome reads it from your disk.

1. Turn on file access for the extension. You do this once per browser.

    Open `chrome://extensions`, click **Details** on Reduck, and turn on
    **Allow access to file URLs**.

    ::video 658e7c6d24ba2f18926b164ebbf135f0 Turn on Allow access to file URLs for the Reduck extension

    > [!NOTE]
    > On macOS, Chrome may also ask for access to your Desktop folder. Allow it.

2. Put the file in the `reduck` folder on your Desktop. Create the folder if it does not exist.

    ```bash
    mkdir -p ~/Desktop/reduck
    cp ~/Downloads/one-integration-every-website.png ~/Desktop/reduck/
    ```

3. Ask your agent:

    ```markdown
    Using Reduck MCP, send one-integration-every-website.png from my reduck folder
    to me@example.com by Gmail, with the subject "Our new banner".
    ```

    The agent makes one `run_script` call. The file is named relative to the `reduck` folder:

    ```json
    {
        "script": {
            "host": "mail.google.com",
            "slug": "send_email",
            "handle": "reduck",
            "args": {
                "to": "me@example.com",
                "subject": "Our new banner"
            },
            "files": {
                "attachment": { "relativePath": "one-integration-every-website.png" }
            }
        }
    }
    ```

    The file keeps its own name, so the email arrives with `one-integration-every-website.png`
    attached. A file in a sub-folder is named with its path: `2026/invoice.pdf`.

> [!NOTE]
> The agent can only name files inside `~/Desktop/reduck`. An absolute path or a name with `..` is
> rejected, so no other file on your machine can be attached, even by a prompt you did not write.

## From the CLI

The CLI runs on your machine, so it reads the file itself and sends the bytes with the run. There is
nothing to set up, and the file can be anywhere.

```bash
npx @reduck-ai/cli@latest run \
  --script reduck/mail.google.com/send_email \
    to=me@example.com \
    subject="Our new banner" \
    attachmentName=one-integration-every-website.png \
    file:attachment=~/Downloads/one-integration-every-website.png
```

`file:attachment=<path>` binds the file input named `attachment` to a file on your disk. Bytes carry
no file name, so `attachmentName` gives the name the recipient sees. Without it, the file arrives
named `attachment`. The result comes back as JSON:

```json
{
    "sent": true,
    "to": ["me@example.com"],
    "cc": [],
    "bcc": [],
    "subject": "Our new banner",
    "attachment": "one-integration-every-website.png"
}
```

Sending the bytes, from the CLI or the REST API, is the only way that works on a
[managed browser](/docs/core-concepts#browser), because a managed browser cannot see your disk.

## From the REST API

`POST /run` takes a file in two ways. Both call the same script as above.

**Send the bytes.** Send the request as `multipart/form-data`: the usual JSON body goes in a `spec`
field, and the file goes in a part named `<step>:<file input>`. For a single `script`, the step is
`0`. A file can be up to 50 MB.

```bash
curl -X POST https://mcp.reduck.ai/run \
  -H "X-API-Key: $REDUCK_API_KEY" \
  -F 'spec={"browser":"extension","script":{"host":"mail.google.com","slug":"send_email","handle":"reduck","args":{"to":"me@example.com","subject":"Our new banner","attachmentName":"one-integration-every-website.png"}}}' \
  -F '0:attachment=@one-integration-every-website.png'
```

As with the CLI, bytes carry no file name, so pass `attachmentName`.

**Name a file on your machine.** Send JSON, with the file in `files`, as the agent does. This works
only on your own Chrome, with file access turned on (see [From your agent](#from-your-agent-mcp)).

```bash
curl -X POST https://mcp.reduck.ai/run \
  -H "X-API-Key: $REDUCK_API_KEY" \
  -H "content-type: application/json" \
  -d '{"browser":"extension","script":{"host":"mail.google.com","slug":"send_email","handle":"reduck","args":{"to":"me@example.com","subject":"Our new banner"},"files":{"attachment":{"relativePath":"one-integration-every-website.png"}}}}'
```

Both answer with the script's result and a `runId`:

```json
{
    "result": {
        "sent": true,
        "to": ["me@example.com"],
        "cc": [],
        "bcc": [],
        "subject": "Our new banner",
        "attachment": "one-integration-every-website.png"
    },
    "runId": "86b0479f-a68f-4fcd-92d1-b68f485ee3d9"
}
```

`browser: "extension"` runs on your own Chrome, where you are signed in to Gmail. Without it, the
run goes to a managed browser, which needs a [connector](/docs/core-concepts#browser) for Gmail.

> [!NOTE]
> The JSON body is limited to 100 KB, so you can also put a very small file inline as base64:
> `"files": {"attachment": {"b64": "…", "mime": "text/plain"}}`. For anything bigger, use
> multipart.

## Check the result

A run that attaches a file ends like any other run. To confirm the file arrived, read the message
back:

```markdown
Using Reduck MCP, find the email with the subject "Our new banner" and list its attachments.
```

```json
{
    "subject": "Our new banner",
    "messages": [
        {
            "to": ["me@example.com"],
            "attachments": ["one-integration-every-website.png"]
        }
    ]
}
```

## Write a script that takes a file

A file input is a string property marked `format: "file"` in the script's input schema. Its key is
the name the script uses for the file.

```json
{
    "type": "object",
    "required": ["to", "subject"],
    "properties": {
        "to": { "type": "string" },
        "subject": { "type": "string" },
        "attachment": { "type": "string", "format": "file" }
    }
}
```

In the script, one line puts the file into a file field of the page. It is the same line for both
ways of giving the file:

```typescript
await builtins.uploadFile("input[type=file]", "attachment");
```

Two rules to know:

- **A file input is optional unless `required` lists it.** Listed, a run with no file stops with
  `missing file input "attachment"`. Not listed, the script checks `files.attachment` before it
  calls `uploadFile`, so one script serves the caller with a file and the caller without one.
- **Bytes arrive under the input's name.** A file named by `relativePath` keeps its own name, but
  bytes from the CLI reach the page as a file named `attachment`. If the site shows the file name,
  as Gmail does, take the real name as an ordinary argument and rename the file in the page. That
  is what `attachmentName` does in the example.

## When it does not work

Each failure stops the run before anything is sent, and says what to fix.

- `This paired browser can't read local files`: **Allow access to file URLs** is off. Turn it on in
  `chrome://extensions`, then run again.
- `must be a plain name inside the Reduck folder`: the name is an absolute path, or contains `..`.
  Name the file relative to `~/Desktop/reduck`.
- `bound 0 bytes — the browser could not read`: the file is not in the folder, or Chrome cannot read
  your Desktop. Check the file is in `~/Desktop/reduck`. On macOS, allow Chrome to read the Desktop
  folder.
- `a managed browser can't read a file from your machine`: a file was named on a managed run. Use
  the CLI, which sends the bytes.
- `unknown file input` or `missing file input`: the names you gave do not match the script's file
  inputs. Read the script's inputs and use the same names.
- `Payload Too Large` (HTTP 413) from the REST API: a base64 file made the JSON body bigger than
  100 KB. Send the file with multipart instead.

> [!NOTE]
> Turning on **Allow access to file URLs** restarts the extension. Your device can be missing from
> the device list for a minute. Wait, then run again.
