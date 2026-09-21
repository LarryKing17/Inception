# Technical Documentation (Architecture)

## Data & Security Management
- **Persistent Volumes**: WordPress and MariaDB data are stored locally on the host machine (`/home/<login>/data/`) to ensure data persistence even if containers crash or are restarted.
- **Secrets**: Passwords are not stored in plain text within the codebase. They are managed via local files securely injected into `/run/secrets/` by Docker Compose.
- **Isolated Network**: Containers communicate through an internal bridge network called `inception_net`. NGINX is the only container exposed to the outside world (port 443).

## Initialization Process (Entrypoints)
- **MariaDB**: Checks for the existence of the custom database. If absent, it initializes the system, creates the database and the user with appropriate privileges, and secures the root account.
- **WordPress**: Checks for the existence of `wp-config.php`. If absent, it downloads WP via wp-cli, waits for the database to be fully ready, creates the configuration file, and runs the core installation (creating the required administrator and author accounts).