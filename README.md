On Pi:
```
mkdir -p ~/nextcloud-upload
```

On Windows:
```
scp file.zip raspberrypi@raspberrypi:~/nextcloud-upload/
```

On Pi:
```
sudo mv ~/nextcloud-upload/file.zip /mnt/ssd/nextcloud/data/admin/files/
docker exec -u www-data nextcloud php occ files:scan --user=admin
```
