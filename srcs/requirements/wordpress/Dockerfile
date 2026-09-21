# 1. On part sur Debian 12 (Bookworm) comme pour MariaDB
FROM debian:bookworm

# 2. Installation de PHP 8.2, des extensions pour MariaDB, et de curl (pour télécharger WP-CLI)
RUN apt-get update && apt-get install -y \
    php8.2-fpm \
    php8.2-mysql \
    curl \
    mariadb-client \
    && rm -rf /var/lib/apt/lists/*

# 3. Téléchargement et installation de WP-CLI (l'outil magique pour installer WordPress)
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x wp-cli.phar \
    && mv wp-cli.phar /usr/local/bin/wp

# 4. Création des dossiers nécessaires (pour le socket PHP et pour le site web)
RUN mkdir -p /run/php \
    && mkdir -p /var/www/wordpress \
    && chown -R www-data:www-data /var/www/wordpress

# 5. On copie ton fichier de configuration PHP pour écraser celui par défaut
COPY conf/www.conf /etc/php/8.2/fpm/pool.d/www.conf

# 6. On copie et on donne les droits à ton script d'initialisation
COPY tools/entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/entrypoint.sh

# 7. On indique que ce conteneur communiquera sur le port 9000
EXPOSE 9000

# 8. La commande lancée au démarrage
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]