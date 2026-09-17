---
title: The REST API
description: Run scripts over HTTP from your own code, with an API key and nothing to install.
section: using-reduck
order: 230
---

The REST API calls scripts over HTTP, with no MCP server and nothing to install. Use it when your
caller has an HTTP client but no agent: a backend, a headless job, an orchestrator such as n8n.

Create a key at [reduck.ai/api-keys](https://reduck.ai/api-keys), then:

```bash
curl https://mcp.reduck.ai/run \
  --header "X-API-Key: $REDUCK_API_KEY" \
  --header "Content-Type: application/json" \
  --data '{"script":{"handle":"reduck","host":"airbnb.com","slug":"search","args":{"city":"Lisbon"}}}'
```

> The API is the door built for [managed browsers](/docs/core-concepts#browser). A script that
> needs your own Chrome is easier to reach through MCP or the CLI.

Every endpoint, with its request and response, is in the [API reference](/docs/api-reference).
[Authentication](/docs/authentication) covers API keys and OAuth tokens.
