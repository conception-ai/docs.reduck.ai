<p align="center">
  <img src="https://cdn.reduck.ai/logo-full-dark.png" alt="Reduck" width="300" />
</p>

# Reduck CLI

[![npm]](https://www.npmjs.com/package/@reduck-ai/cli) ![](https://img.shields.io/badge/Node.js-22%2B-brightgreen?style=flat-square)

[npm]: https://img.shields.io/npm/v/@reduck-ai/cli.svg?style=flat-square

Reduck CLI is a command-line tool that connects your browser to [Reduck](https://reduck.ai) and lets you discover, run, and chain saved browser automation scripts — all from your terminal.

## Get started

1. Authenticate:

    ```bash
    npx @reduck-ai/cli@latest login
    ```

2. Run a script:

    ```bash
    npx @reduck-ai/cli@latest run --script linkedin.com/get_profile_info username=dhuynh95
    ```

## Hosted apps — `flock`

`flock` deploys a folder as a hosted app: one React file, its SQL schema, and two small JSON files.

```bash
npx @reduck-ai/cli@latest flock deploy ./my-app     # → https://flock-staging.reduck.ai/app/<uuid>
```

The first deploy mints the app's uuid and writes `flock.json` into the folder — commit it and a
colleague deploys to the same app. From there:

```bash
npx @reduck-ai/cli@latest flock sql "SELECT * FROM answers LIMIT 5"  # the app's database, or bare for a prompt
npx @reduck-ai/cli@latest flock db                                  # tables, row counts, size — db:download, db:reset
npx @reduck-ai/cli@latest flock files                               # its blobs — files:get, files:put, files:add, files:rm
npx @reduck-ai/cli@latest flock secrets:set NOTION_TOKEN=secret_…   # values behind ${VAR} in .api-keys.json
npx @reduck-ai/cli@latest flock config:set brand.domain=reduck.ai   # the app's settings document
npx @reduck-ai/cli@latest flock access authenticated                # any Reduck account may open it
npx @reduck-ai/cli@latest flock releases                            # …and `rollback <n>`
```

`sql` and `files` go through the page's own doors, so what you read is what the page sees.

The page runs Reduck scripts and calls Claude with no key of its own: whoever opens it signs in to
Reduck, and their token is what the calls are made with. `flock --help` lists the rest.

## Authentication

`npx @reduck-ai/cli@latest login` runs an OAuth2 PKCE flow against the authorization server the MCP advertises, requesting a token scoped to the MCP. Credentials are stored in `~/.config/reduck/config.json` (mode `0600`) and refreshed automatically; `logout` clears them.

You can also authenticate with an API key by setting `REDUCK_API_KEY`.

## Experimental features

Features in early access are enabled per account. Their commands are hidden from `--help` unless
`REDUCK_EXPERIMENTAL=1` is set, and still work when invoked directly.

A command belonging to a feature your account is not enabled for returns `403`. Request early
access at https://form.reduck.ai or contact Reduck at contact@reduck.ai

## Reporting bugs

Reach out on [Discord](https://discord.com/invite/MPBQWCVTAq).

## License

MIT
