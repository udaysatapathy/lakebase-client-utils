# pgAdmin 4: sign in to Lakebase without copying tokens

pgAdmin's **Password exec command** setting (Server dialog > Advanced tab) runs a shell command and uses its output as the password. Point it at a script that asks the Databricks CLI for a fresh Lakebase database credential, and pgAdmin connects with the user's existing Databricks sign-in.

## Option 1: automatic setup (recommended)

`lakebase-pgadmin.py` does the whole setup with one command. It uses only the Python standard library.

```bash
python3 lakebase-pgadmin.py --profile <cli-profile> --project <project-id>
```

It does four things:

1. Looks up your Postgres user name, the project's default branch and the branch's read-write endpoint and host. The lookups go through the Databricks CLI.
2. Writes a token script for that endpoint to `~/.lakebase-pgadmin/` with owner-only permissions.
3. Writes a pgAdmin server definition (JSON).
4. Backs up pgAdmin's config database and adds the server using pgAdmin's own `setup.py load-servers` command.

Restart pgAdmin, or refresh the Object Explorer, to see the server under the **Lakebase** group. Then connect; no password is needed.

Useful options:

| Option | Purpose |
|---|---|
| `--branch`, `--endpoint` | Target a specific branch or endpoint instead of the defaults. |
| `--dry-run` | Show what would happen. Nothing is written. |
| `--json-only` | Write the JSON for **Tools > Import/Export Servers** instead of loading it. |
| `--test-token` | Check that a credential can be fetched. The token is never printed. |
| `--name`, `--group` | Set the server's name and group in pgAdmin. |
| `--expiration` | Seconds before pgAdmin fetches a new credential. Keep it under 3600, because credentials last one hour (default 3000). |

The tool won't add a server whose name already exists. It never uses `load-servers --replace`, because that would drop saved passwords for every other server.

## Option 2: manual setup

1. Copy the template for your OS (`macos/`, `linux/` or `windows/`). Fill in the CLI path, endpoint and profile.
2. Run the script once in a terminal to check that it prints a token.
3. In pgAdmin, open **Register > Server** and fill in these fields:

| Tab | Field | Value |
|---|---|---|
| Connection | Host | Endpoint host from the Lakebase **Connect** dialog |
| Connection | Port / Maintenance DB | `5432` / `databricks_postgres` |
| Connection | Username | Your Postgres role, usually your Databricks user name |
| Connection | Password | Leave blank. Turn off **Save password**. |
| Parameters | SSL mode | `require` |
| Advanced | Password exec command | Full path to your script. On Windows, use the PowerShell command shown in the template. |
| Advanced | Password exec expiration | `3000` |

## Limits

- **Desktop mode only.** In pgAdmin server mode, password exec commands must be pre-defined by the administrator in `SERVER_PASSEXEC_COMMANDS`. Use `--json-only` and give the JSON to your pgAdmin admin.
- **Sign in to the CLI first.** pgAdmin can't open a browser sign-in. If the CLI session needs a fresh browser login, run `databricks auth login --profile <profile>` again.
- **Use absolute paths.** Desktop apps don't inherit your shell's `PATH`, so the scripts use absolute paths to the CLI.
- **Tested platforms.** Only macOS has been tested. The Windows and Linux paths are written to the same design but haven't been run.
