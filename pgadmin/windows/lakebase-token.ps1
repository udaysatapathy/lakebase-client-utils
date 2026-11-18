# Prints a fresh Lakebase database credential for pgAdmin's "Password exec command".
# Uses the Databricks CLI's existing sign-in (Microsoft Entra ID on Azure Databricks);
# nobody copies a token.
#
# Untested on Windows.
# 1. Sign in once:  databricks auth login --host https://<workspace-url> --profile <cli-profile>
# 2. Fill in the values below. Find the CLI with:  (Get-Command databricks).Source
# 3. In pgAdmin, set "Password exec command" to:
#      powershell.exe -NoProfile -ExecutionPolicy Bypass -File "C:\path\to\lakebase-token.ps1"
#    and "Password exec expiration" to 3000.

$ErrorActionPreference = "Stop"

$DatabricksCli = "C:\path\to\databricks.exe"
$Endpoint      = "projects/<project-id>/branches/<branch-id>/endpoints/<endpoint-id>"
$DbProfile     = "<cli-profile>"   # not $Profile, which is a built-in PowerShell variable

$credential = & $DatabricksCli postgres generate-database-credential $Endpoint --profile $DbProfile -o json | ConvertFrom-Json
[Console]::Out.Write($credential.token)
