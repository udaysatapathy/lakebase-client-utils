#!/bin/bash
# Prints a fresh Lakebase database credential for pgAdmin's "Password exec command".
# Uses the Databricks CLI's existing sign-in; nobody copies a token.
#
# Untested on Linux. Fill in the three values, then: chmod 700 lakebase-token.sh
# Find the CLI path with: command -v databricks   (often /usr/local/bin/databricks)
set -euo pipefail

DATABRICKS_CLI="/usr/local/bin/databricks"
ENDPOINT="projects/<project-id>/branches/<branch-id>/endpoints/<endpoint-id>"
PROFILE="<cli-profile>"

"$DATABRICKS_CLI" postgres generate-database-credential "$ENDPOINT" \
  --profile "$PROFILE" -o json \
  | /usr/bin/python3 -c 'import json,sys; sys.stdout.write(json.load(sys.stdin)["token"])'
