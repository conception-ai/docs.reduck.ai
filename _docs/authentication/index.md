---
title: Authentication
description: API keys, OAuth tokens, and why a token issued for one Reduck door is rejected at the other.
section: security
order: 300
---

Two credentials reach Reduck: an **API key** you create and keep, or an **OAuth access token** your
client obtains by signing you in. Which one you want depends on whether a browser is in the loop.

## API keys

A long-lived key, made for code: a backend, a cron, an orchestrator such as n8n. Create one at
[reduck.ai/api-keys](https://reduck.ai/api-keys) and send it as a header:

```bash
curl https://mcp.reduck.ai/run \
  --header "X-API-Key: $REDUCK_API_KEY" \
  --header "Content-Type: application/json" \
  --data '{"script":"@reduck/airbnb.com/search","args":{"city":"Lisbon"}}'
```

The same key works for the [CLI](/docs/cli), where setting
`REDUCK_API_KEY` replaces `login`. A key acts as you, with everything your account can do, so treat
it as a password: keep it out of version control, and delete it from the dashboard the moment it
leaks. Deleting is what revokes it — there is no expiry to wait for.

## OAuth

This is what your agent does on its own. The first time a client calls a Reduck tool it sends you
to your browser to approve, and gets back an access token that refreshes itself. You will not see
it; the client stores it.

The CLI does the same through `login`, and keeps the result in `~/.config/reduck/config.json`,
readable only by you. `logout` removes it.

### Scopes

A token is granted only what its client asked for:

| Scope                                | Allows                                          |
| ------------------------------------ | ----------------------------------------------- |
| `script:read` / `script:write`       | Read scripts, and create or change them         |
| `run:read` / `run:write`             | Read runs and their traces, and start runs      |
| `device:read`                        | List your paired browsers                       |
| `connector:read` / `connector:write` | Read and write [connectors](/docs/connectors)   |
| `app:read` / `app:write`             | Read and write hosted apps                      |
| `openid`, `profile`, `email`         | Who you are                                     |
| `offline_access`                     | Refresh without sending you back to the browser |

## One token, one door

Reduck answers at two addresses, and they are separate resources: the API at `https://reduck.ai`
and the MCP server at `https://mcp.reduck.ai`.

A token names the one it was issued for — the `resource` parameter of the request that minted it —
and is rejected at the other, even though both belong to Reduck and to you. So a token your agent
holds for the MCP server cannot be used against the API, and a token your app holds for the API is
not accepted by the MCP.

That is the MCP specification's rule about token privilege, and it is why the token your client
gives the MCP server is never passed on to the API: the MCP calls the API with a credential of its
own instead. A stolen token is good for one door and nothing behind it.

If you are minting a token yourself for the [REST API](/docs/api-reference), ask for
`resource=https://reduck.ai`. A token obtained for the MCP will not work there, and the error will
tell you so.

## What a script sees

None of this. A credential proves who is asking; it is not what a script uses to sign into a
website. That is a separate question, answered on
[Where credentials live](/docs/credentials).
