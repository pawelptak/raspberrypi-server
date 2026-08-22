Important files are backed up regularly using `crontab`. My current crontab is saved in `my-crontab.txt`.

# rsync-backup.sh
This script makes a backup of a chosen folder with the `rsync` command. Every step of the backup is checked and logged to node-exporter, so I can monitor that the backup is working.

It is used to back up [Nextcloud](../nextcloud) and [Home Assistant](../homeassistant).

# Immich backup
The [Immich](../immich) files are backed up with two scripts in the immich folder: `immich-borg-setup.sh` (backup to a second SSD) and `immich-borg-remote.sh` (backup to a remote PC). See the Immich folder for more details.