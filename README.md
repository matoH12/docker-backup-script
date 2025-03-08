# docker-backup-script
## Description
This Bash script performs automatic backups of Docker configuration files and environment variables for all running containers. The backups are stored in the `/backup/docker` directory, and backups older than 30 days are automatically deleted.

## Requirements
- Docker installed and running on the system.
- `red5d/docker-autocompose` image available for exporting Docker Compose files.
- Access to `/var/run/docker.sock` to interact with the Docker daemon.

## Installation

1. Copy the script into a file, e.g., `backup_docker.sh`.
2. Ensure the script is executable:
   ```bash
   chmod +x backup_docker.sh
   ```
3. Run the script manually or add it to crontab for automatic execution:
   ```bash
   crontab -e
   ```
   Add the following line to schedule daily execution at midnight:
   ```bash
   0 0 * * * /path/to/backup_docker.sh
   ```

## Usage

Run the script manually:
```bash
./backup_docker.sh
```

Upon execution, the script performs the following steps:
1. Checks and creates the backup directory if it does not exist.
2. For each running container:
   - Exports its Docker Compose definition to a YAML file.
   - Saves environment variables to a text file.
3. Creates a tar.gz archive of all backup files.
4. Deletes backups older than 30 days.

## Configuration

To modify:
- **Backup directory**, update the `BACKUP_DIR` variable.
- **Retention period for old backups**, update the `RETENTION_DAYS` variable.

## Notes
- This script does not back up Docker volumes or stored data inside containers, only configuration files and environment variables.
- For full data backup, consider using `docker save` or other tools.

## Author
Martin Hasin matoH12

## License
MIT License

