# lakebase-client-utils

Utilities for connecting desktop database clients to [Databricks Lakebase](https://docs.databricks.com/aws/en/oltp/) (managed Postgres) with Databricks sign-in, so users don't copy database tokens by hand.

> **Disclaimer.** This is not an official Databricks product or service. It is provided "as is", without warranty, support commitment or SLA. Test it on non-production projects first.

## How it works

Lakebase accepts a short-lived database credential, which the Databricks CLI can create for a signed-in user. Desktop tools that can run a command to fetch a password can use the CLI's existing browser sign-in (Microsoft Entra ID on Azure Databricks, or your identity provider on AWS and GCP). Users sign in to the CLI once and connect without pasting a token.

## Contents

| Folder | What it contains |
|---|---|
| [`pgadmin/`](pgadmin/) | Registers a Lakebase endpoint in pgAdmin 4 with single sign-on, plus per-OS token script templates. |

## Status

| Client | macOS | Windows | Linux |
|---|---|---|---|
| pgAdmin 4 (desktop mode) | Tested with pgAdmin 4 9.19 | Untested | Untested |

Contributions for other clients are welcome. DBeaver, DataGrip and others belong in their own folders.

## Requirements

- The [Databricks CLI](https://docs.databricks.com/aws/en/dev-tools/cli/), signed in with `databricks auth login --host <workspace-url> --profile <profile>`.
- A Lakebase Autoscaling project, and a Postgres role for your Databricks identity. The project owner's role is created automatically. For other users, see [Postgres roles](https://docs.databricks.com/aws/en/oltp/projects/postgres-roles).
