```
0 3 * * * rsync -av --delete /mnt/ssd/nextcloud/data/admin/files /mnt/ssd_backup/nextcloud_backup >> /home/raspberrypi/ApkiPawla/nextcloud/backup_log.log 2>&1
0 3 * * * certbot renew --quiet --deploy-hook "systemctl reload apache2"
0 2 * * * /home/raspberrypi/ApkiPawla/immich/immich-borg-setup.sh >> /home/raspberrypi/ApkiPawla/immich/backup_log.log 2>&1
0 1 1 * * /home/raspberrypi/ApkiPawla/goaccess/update-geo-db.sh

# space cleanup every sunday 3:30 AM
30 3 * * 0 docker system prune -a -f && truncate -s 0 /var/lib/docker/containers/*/*-json.log && apt-get clean && journalctl --vacuum-size=500M && truncate -s 0 /home/raspberrypi/ApkiPawla/pihole/etc-pihole/pihole-FTL.db

# copy home assistant backup files to second ssd
0 4 * * * rsync -av --delete /mnt/ssd/homeassistant/backups/ /mnt/ssd_backup/homeassistant_backup/ >> /home/raspberrypi/ApkiPawla/homeassistant/backup_log.log 2>&1
```
