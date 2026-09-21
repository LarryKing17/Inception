#!/bin/bash
set -e # Arrête le script immédiatement si une commande échoue

# 1. Lecture des mots de passe depuis les secrets montés en RAM par Docker
DB_ROOT_PWD=$(cat /run/secrets/db_root_password)
DB_PWD=$(cat /run/secrets/db_password)

# 2. Vérification : Est-ce que le volume est vide ?
if [ ! -d "/var/lib/mysql/${MYSQL_DATABASE}" ]; then
    echo "=> Initialisation de la base de données..."
    
    # Prépare les dossiers internes de MariaDB
    mysql_install_db --user=mysql --datadir=/var/lib/mysql > /dev/null

    # Démarre temporairement le serveur en arrière-plan pour exécuter nos requêtes
    mysqld_safe --nowatch &
    
    # On attend que le serveur soit prêt à recevoir des commandes (remplace le "sleep" interdit)
    while ! mysqladmin ping -h localhost --silent; do
        sleep 1
    done

    echo "=> Création de l'utilisateur et de la base de données..."
    
    # Création de la DB et de l'utilisateur (Le % autorise la connexion depuis n'importe quel conteneur)
    mysql -u root -e "CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;"
    mysql -u root -e "CREATE USER IF NOT EXISTS \`${MYSQL_USER}\`@'%' IDENTIFIED BY '${DB_PWD}';"
    mysql -u root -e "GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO \`${MYSQL_USER}\`@'%';"
    
    # Sécurisation du compte root (changement du mot de passe)
    mysql -u root -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${DB_ROOT_PWD}';"
    mysql -u root -p"${DB_ROOT_PWD}" -e "FLUSH PRIVILEGES;"

    # On éteint le serveur temporaire proprement
    mysqladmin -u root -p"${DB_ROOT_PWD}" shutdown
fi

echo "=> Démarrage de MariaDB au premier plan (PID 1)..."
# Le mot-clé 'exec' est vital : il remplace le script bash par le processus mysqld_safe.
# mysqld_safe devient ainsi le PID 1 !
exec mysqld_safe