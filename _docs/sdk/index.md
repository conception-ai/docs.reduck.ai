---
title: The TypeScript SDK
description: Manage scripts, devices and runs from your own code, fully typed against the Reduck API.
section: using-reduck
order: 230
---

`@reduck-ai/sdk` is a typed client for the Reduck REST API, generated from its OpenAPI document —
so every input and response autocompletes in your editor and cannot drift from the API it calls.

```bash
npm install @reduck-ai/sdk
```

```typescript
import { createReduckClient, listScripts } from "@reduck-ai/sdk";

const client = createReduckClient({ apiKey: REDUCK_API_KEY });

const { data: scripts } = await listScripts({
	client,
	path: { handle: "@username" },
	query: { q: "linkedin" }
});
```

Every function takes `{ client, path?, query?, body? }` and returns `{ data, error }`.

## Signing in

`createReduckClient` takes exactly one credential:

```typescript
const client = createReduckClient({ apiKey: "<your-api-key>" }); // server-side
const client = createReduckClient({ oauthToken: "<access-token>" }); // user-facing apps
```

An API key is the one to use from your own backend — create it at
[reduck.ai/api-keys](https://reduck.ai/api-keys). An OAuth token has to be issued **for this API**:
request it with `resource=https://reduck.ai` and the scopes your calls need. A token obtained for
the MCP server is rejected here; see [Authentication](/docs/authentication).

## What it covers

| Function                            | Args besides `client`                                                     |
| ----------------------------------- | ------------------------------------------------------------------------- |
| `getMe`                             | —                                                                         |
| `listDevices`                       | —                                                                         |
| `listRuns`                          | `query: { page?, pageSize? }`                                             |
| `getRun`                            | `path: { runId }`                                                         |
| `listAllScripts`                    | `query: { host?, q?, visibility?, archived? }`                            |
| `listScripts`                       | `path: { handle }`, `query: { host?, slug?, visibility?, archived?, q? }` |
| `getScript`                         | `path: { handle, host, slug }`                                            |
| `createScript`                      | `path: { handle }`, `body`                                                |
| `patchScript`                       | `path: { handle, host, slug }`, `body: { name?, description? }`           |
| `publishScript` / `unpublishScript` | `path: { handle, host, slug }`                                            |
| `archiveScript` / `restoreScript`   | `path: { handle, host, slug }`                                            |
| `listScriptVersions`                | `path: { handle, host, slug }`, `query`                                   |
| `createDraftScriptVersion`          | `path: { handle, host, slug }`, `body`                                    |
| `getScriptVersion`                  | `path: { handle, host, slug, versionId }`                                 |
| `listScriptTransferTargets`         | `path: { handle, host, slug }`                                            |
| `transferScript`                    | `path: { handle, host, slug }`, `body: { target }`                        |

`handle` is `@username` for your own scripts, or a project slug for a
[project](/docs/projects)'s. List functions return `{ data, hasNextPage }`.

Running a script is not in this table: the SDK manages the catalogue, and runs go through
`POST /run`, the MCP, or the [CLI](/docs/cli).

## Errors

Nothing throws. A failed request returns the server's error and leaves `data` undefined:

```typescript
const { data, error } = await getScript({ client, path: { handle, host, slug } });
if (error) {
	console.error(error.error); // or error.variables, per field
	return;
}
```

Every endpoint behind these functions is listed in the [API reference](/docs/api-reference).
