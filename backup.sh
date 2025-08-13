#!/bin/bash


DATE=$(date +%F)


WEB_DIR="/var/www/yourSiteDir"
BACKUP_DIR="/backups/yourBackupDir"

DB_USER="db_username"
DB_PASS="db_password"
DB_NAME="db_name"


mkdir -p "$BACKUP_DIR"

tar -czf "$BACKUP_DIR/site-files-$DATE.tar.gz" -C "$WEB_DIR" .


mysqldump -u "$DB_USER" -p"$DB_PASS" "$DB_NAME" > "$BACKUP_DIR/site-db-$DATE.sql"


gzip "$BACKUP_DIR/site-db-$DATE.sql"

find "$BACKUP_DIR" -type f -mtime +7 -exec rm {} \;


echo "Backup completed for $DATE"
