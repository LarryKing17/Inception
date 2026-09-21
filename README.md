# Inception

This project aims to broaden our knowledge of system administration by using Docker.  
We are required to virtualize several Docker images, building them ourselves from the latest stable version of Debian.

## Project Architecture
The project consists of 3 distinct containers, connected through an internal Docker network:
- **NGINX**: The web server (Entry point, TLS/HTTPS only on port 443).
- **WordPress**: The website (PHP-FPM), configured automatically via WP-CLI.
- **MariaDB**: The relational database.

Each container is strictly responsible for a single task and runs in the foreground (PID 1).