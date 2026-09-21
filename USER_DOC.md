# User Manual

## Prerequisites
- Modify the host machine's `hosts` file to map `127.0.0.1` to `<login>.42.fr`.
- Docker and Docker Compose must be installed on the system.

## Commands (Makefile)
- `make` or `make all`: Builds the images, creates the local data directories, and starts the containers in the background.
- `make down`: Stops the containers without destroying the persistent data.
- `make clean`: Stops the containers and removes unused Docker images.
- `make fclean`: Removes all images, Docker volumes, and completely clears the local data directories. Resets the project to zero.
- `make re`: Executes `fclean` followed by `all`.

## Access
- Website URL: `https://<login>.42.fr`
- Admin panel: `https://<login>.42.fr/wp-admin`