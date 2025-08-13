# Website + MySQL Backup Script

## Overview
`backup.sh` is a simple Bash script that:
- Creates a backup of your website files.
- Dumps your MySQL or MariaDB database.
- Compresses the database backup.
- Removes backups older than 7 days.

---

## How It Works
1. Get the current date to name the backup files.
2. Archive and compress the website directory (`tar.gz`).
3. Dump the MySQL database using `mysqldump`.
4. Compress the `.sql` file using `gzip`.
5. Remove old backup files (older than 7 days).
6. Print a success message.

---

## Configuration
Edit the top section of `backup.sh` and replace the placeholder values with your own:
```bash
WEB_DIR="/var/www/yourSiteDir"        # Path to your website files
BACKUP_DIR="/backups/yourBackupDir"   # Directory where backups will be stored

DB_USER="db_username"                 # Database username
DB_PASS="db_password"                 # Database password
DB_NAME="db_name"                     # Database name
````

---

## Usage

### 1️ Run Manually

```bash
chmod +x backup.sh
./backup.sh
```

### 2️ Run Automatically with Cron

To run the backup daily at 2 AM:

```bash
crontab -e
```

Add:

```bash
0 2 * * * /bin/bash /path/to/backup.sh >> /var/log/backup.log 2>&1
```

---

## Optional: Run as a systemd Service

You can use **systemd** instead of Cron for better logging and control.

1. Place the script in `/usr/local/bin/backup.sh`.
2. Create a service file:

   ```ini
   # /etc/systemd/system/site-backup.service
   [Unit]
   Description=Daily Site Backup Service
   Wants=site-backup.timer

   [Service]
   Type=oneshot
   ExecStart=/usr/local/bin/backup.sh
   User=root
   ```
3. Create a timer file:

   ```ini
   # /etc/systemd/system/site-backup.timer
   [Unit]
   Description=Run Site Backup Daily

   [Timer]
   OnCalendar=*-*-* 02:00:00
   Persistent=true

   [Install]
   WantedBy=timers.target
   ```
4. Reload systemd and enable:

   ```bash
   sudo systemctl daemon-reload
   sudo systemctl enable --now site-backup.timer
   ```

---

## Notes

* Make sure the script has permission to read the website directory and dump the database.
* To restore:

  * Website files: `tar -xzf site-files-YYYY-MM-DD.tar.gz -C /var/www/yourSiteDir`
  * Database: `gunzip -c site-db-YYYY-MM-DD.sql.gz | mysql -u DB_USER -p DB_NAME`



If you want, I can add a **full restore section with step-by-step commands** so the README covers the complete backup + restore workflow. Would you like me to include that?
```
