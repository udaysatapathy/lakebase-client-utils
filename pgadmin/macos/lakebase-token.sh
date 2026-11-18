#!/bin/bash
# Prints a fresh Lakebase database credential for pgAdmin's "Password exec command".
# Uses the Databricks CLI's existing sign-in; nobody copies a token.
#
# Fill in the three values, then: chmod 700 lakebase-token.sh
# Find the CLI path with: command -v databricks   (Homebrew: /opt/homebrew/bin/databricks)
set -euo pipefail

DATABRICKS_CLI="/opt/homebrew/bin/databricks"
ENDPOINT="projects/<project-id>/branches/<branch-id>/endpoints/<endpoint-id>"
PROFILE="<cli-profile>"

"$DATABRICKS_CLI" postgres generate-database-credential "$ENDPOINT" \
  --profile "$PROFILE" -o json \
  | /usr/bin/jq -r .token   # jq ships with macOS 15 and later; use `brew install jq` on older versions
