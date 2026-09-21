# Chemins vers les dossiers de données sur ton PC physique
WP_DATA = /home/$(USER)/data/wordpress
DB_DATA = /home/$(USER)/data/mariadb

# Le lancement classique (règle par défaut quand on tape 'make')
all:
	@mkdir -p $(WP_DATA)
	@mkdir -p $(DB_DATA)
	docker compose -f srcs/docker-compose.yml up -d --build

# Arrêter les conteneurs sans détruire les données
down:
	docker compose -f srcs/docker-compose.yml down

# Arrêter les conteneurs et supprimer les images Docker pour faire de la place
clean: down
	docker system prune -af

# Le grand nettoyage : supprime TOUT (images, volumes, et tes fichiers de base de données)
fclean: clean
	sudo rm -rf $(WP_DATA) $(DB_DATA)
	docker volume rm $$(docker volume ls -q) 2>/dev/null || true

# On supprime tout et on recommence à zéro
re: fclean all

.PHONY: all down clean fclean re