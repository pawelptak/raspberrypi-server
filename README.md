# Rasberry Pi Server
Self hosting various services on Raspberry Pi 5

# Services
- [immich](immich/README.md)
- [Plex](plex/README.md)
- [Grafana](grafana/README.md)
- [qBittorrent](qbittorrent/README.md)
- [Radarr](radarr/README.md)
- [Nextcloud](nextcloud/README.md)
- [Pi-hole](pihole/README.md)
- [Apache2](apache2/README.md)
- [GoAccess](goaccess/README.md)
- [ClipYT](clipyt/README.md)
- [Glosy](glosy/README.md)
- [Navidrome](navidrome/README.md)
- [Home Assistant](homeassistant/README.md)
- [Watchtower](watchtower/README.md)

# Prerequisites
- [Docker](https://docs.docker.com/get-docker/)
- [Docker compose](https://docs.docker.com/compose/install/)
- [snap](https://snapcraft.io/docs/installing-snap-on-raspbian)


# Remote access from outside local network
To be able to use all the services remotely [PiVPN](pivpn/README.md) can be used.

# Data backup

## Nextcloud (or any other folder)

1. Install rsync:
    ```
    sudo apt install rsync
    ```

2. (optional) Run rsync manually:
    ```
    sudo rsync -av --delete /home/pi/myfolder/ /mnt/backupdrive/mybackup/
    ```
    (The nextcloud data folder will be something like `.../nextcloud/data/admin/files`)

3. Set up a cron job for automation. Edit the crontab file:
    ```
    sudo crontab -e
    ```
And add the following line (this will run daily at 3:00 AM):

`0 3 * * * rsync -av --delete /home/pi/myfolder/ /mnt/backupdrive/mybackup/ >> /path/to/log/folder/backup_log.log 2>&1`

If something fails check the `backup_log.log` file. More info on the cron syntax [here](https://crontab.guru/).

## Immich
In the `immich` folder you got the .env file and there: `UPLOAD_LOCATION` with all the photos and `DB_DATA_LOCATION` that has the paths to the photos. Both have to be backuped. The database is automatically backuped in `UPLOAD_LOCATION\backups` ([source](https://immich.app/docs/administration/backup-and-restore/#automatic-database-backups)). To create a backup of Immich db and the media files on a separate drive, you need to perform the following steps:

1. Install Borg: 
    ```
    sudo apt install borgbackup
    ```

2. Run the commands from the "Borg set-up" section of the [docs](https://immich.app/docs/guides/template-backup-script/) (I omit the "##Remote set up" part. Add `sudo` for commands that fail).

3. Edit and run the script from the "Borg backup template" section of the [docs](https://immich.app/docs/guides/template-backup-script/) (Again, I omit the "REMOTE_HOST", "REMOTE_BACKUP_PATH" lines and the "### Append to remote Borg repository" section). The script that I used can be found in `data-backup/immich-borg-setup.sh`. Running the script can take a while, since it is creating backup of all the data.

4. Edit the crontab file:
    ```
    sudo crontab -e
    ```
    Add the following line (this will run daily at 2:00 AM):

    `0 2 * * * /path/to/your/immich-borg-setup.sh >> /path/to/log/folder/backup_log.log 2>&1`

5. Make the script executable:
    ```
    sudo chmod +x immich-borg-setup.sh
    ```

6. (optional) If everything works you can disable Immich automatic database backup by going to `http://your-immich-address/admin/system-settings` and unchecking the automatic database backup option.

7. To restore data from a certain point, refer to the [restoring](https://immich.app/docs/guides/template-backup-script/#restoring) section. You restored data will be in the temporary mountpoint that you create. After restoring the data, unmount the mountpoint.

For restoring the immich database itself, keep in mind the [Manual Backup and Restore](https://immich.app/docs/administration/backup-and-restore/#manual-backup-and-restore) section of the docs (The "Restore" part). They mention a `dump.sql.gz` file but we have just a .sql file backed up, so idk? Good luck and may God be with you when doing the restore part.

