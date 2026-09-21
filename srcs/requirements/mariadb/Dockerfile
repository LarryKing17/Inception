# 1. On part de Debian 11 (Bullseye) comme exigé par l'école 42
FROM debian:bookworm

# 2. On met à jour le système et on installe MariaDB
RUN apt-get update && apt-get install -y mariadb-server \
    && rm -rf /var/lib/apt/lists/*

# 3. Création du dossier nécessaire au fonctionnement de MariaDB (les sockets)
RUN mkdir -p /var/run/mysqld \
    && chown -R mysql:mysql /var/run/mysqld \
    && chmod 777 /var/run/mysqld

# 4. On copie tes fichiers locaux vers l'intérieur du conteneur
COPY conf/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf
COPY tools/entrypoint.sh /usr/local/bin/

# 5. On donne le droit d'exécution à ton script bash
RUN chmod +x /usr/local/bin/entrypoint.sh

# 6. On indique que ce conteneur communiquera sur le port 3306
EXPOSE 3306

# 7. La commande qui se lance au démarrage du conteneur
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]