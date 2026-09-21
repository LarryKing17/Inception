#!/bin/bash
set -e

# 1. Lecture des mots de passe depuis les secrets (sans le .txt)
DB_PWD=$(cat /run/secrets/db_password)
WP_ADMIN_PWD=$(cat /run/secrets/credentials)

# 2. On se place dans le dossier qui contiendra le site web
cd /var/www/wordpress

# 3. Est-ce que WordPress est déjà installé ? (on vérifie si wp-config.php existe)
if [ ! -f "wp-config.php" ]; then
    echo "=> Téléchargement de WordPress..."
    wp core download --allow-root

    echo "=> Attente du démarrage complet de MariaDB..."
    sleep 10 # Pause nécessaire pour s'assurer que la base de données est prête à recevoir des requêtes

    echo "=> Création du fichier de configuration (wp-config.php)..."
    wp config create --allow-root \
        --dbname="${MYSQL_DATABASE}" \
        --dbuser="${MYSQL_USER}" \
        --dbpass="${DB_PWD}" \
        --dbhost="mariadb:3306" # On utilise le nom du conteneur mariadb comme adresse réseau !

    echo "=> Installation de WordPress..."
    # Attention : le sujet interdit que l'admin contienne le mot "admin"
    wp core install --allow-root \
        --url="${DOMAIN_NAME}" \
        --title="Inception 42" \
        --admin_user="supervisor" \
        --admin_password="${WP_ADMIN_PWD}" \
        --admin_email="supervisor@${DOMAIN_NAME}"

    echo "=> Création du deuxième utilisateur exigé par le sujet..."
    wp user create --allow-root "author_user" "author@${DOMAIN_NAME}" \
        --user_pass="author_password_123" \
        --role=author
        
    echo "=> WordPress est installé et configuré !"
fi

echo "=> Démarrage de PHP-FPM (PID 1)..."
# Sur Debian 12 (Bookworm), c'est la version 8.2 de PHP.
# Le -F force PHP à tourner au premier plan (devient PID 1)
exec php-fpm8.2 -F