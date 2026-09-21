# 1. Toujours notre base Debian 12
FROM debian:bookworm

# 2. Installation de Nginx et d'OpenSSL (pour le certificat HTTPS)
RUN apt-get update && apt-get install -y \
    nginx \
    openssl \
    && rm -rf /var/lib/apt/lists/*

# 3. Génération du certificat SSL (valable 365 jours) directement à la construction
RUN mkdir -p /etc/ssl/certs /etc/ssl/private && \
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/ssl/private/inception.key \
    -out /etc/ssl/certs/inception.crt \
    -subj "/C=FR/ST=IDF/L=Paris/O=42/OU=42/CN=inception.42.fr/UID=inception"

# 4. On injecte ton fichier de configuration pour écraser celui par défaut
COPY nginx.conf /etc/nginx/nginx.conf

# 5. Création du dossier qui va accueillir les fichiers du site web
RUN mkdir -p /var/www/wordpress && \
    chown -R www-data:www-data /var/www/wordpress

# 6. On indique que ce conteneur communiquera sur le port 443 (HTTPS)
EXPOSE 443

# 7. Démarrage de Nginx (-g daemon off permet de le garder au premier plan / PID 1)
CMD ["nginx", "-g", "daemon off;"]