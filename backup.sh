#!/bin/bash

# Cesta na uloženie záloh
BACKUP_DIR="/backup/docker"
DATE=$(date +'%Y-%m-%d')
RETENTION_DAYS=30  # Počet dní, po ktorých sa zálohy mažú

# Vytvorenie adresára na zálohy, ak neexistuje
mkdir -p $BACKUP_DIR

echo "Zálohovanie Docker konfiguračných súborov a premenných..."

# Pre každý kontajner vytvorí zálohu Docker Compose a env premenných
for container in $(docker ps --format '{{.Names}}'); do
    echo "Spracovávam kontajner: $container"

    # Export Docker Compose súboru
    docker run --rm -v /var/run/docker.sock:/var/run/docker.sock red5d/docker-autocompose $container > $BACKUP_DIR/${container}_docker-compose.yml

    # Export environmentálnych premenných
    docker inspect --format='{{range .Config.Env}}{{println .}}{{end}}' $container > $BACKUP_DIR/${container}_env.txt
done

# Vytvorenie archívu
tar -czf $BACKUP_DIR/docker_backup_$DATE.tar.gz -C $BACKUP_DIR .
echo "Zálohovanie dokončené: $BACKUP_DIR/docker_backup_$DATE.tar.gz"

# Odstránenie starých záloh
find $BACKUP_DIR -type f -name "*.tar.gz" -mtime +$RETENTION_DAYS -exec rm {} \;
echo "Vymazané zálohy staršie ako $RETENTION_DAYS dní."
