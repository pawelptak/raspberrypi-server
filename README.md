On Pi:
```
mkdir -p /mnt/ssd/upload
```

On Windows:
```
scp file.zip raspberrypi@raspberrypi:/mnt/ssd/upload/
```

On Pi:
```
sudo mv /mnt/ssd/upload/file.zip /mnt/ssd/nextcloud/data/admin/files/
docker exec -u www-data nextcloud php occ files:scan --user=admin
```
