# Immich
[Immich](https://github.com/immich-app/immich) is a photo and video management solution.
## Installation
1. Edit the `.env` file from the `immich` directory:
    - Set `UPLOAD_LOCATION` with your preferred location for storing files. `/mnt/ssd/immich` in my case.
    - Change `DB_PASSWORD` to something randomly generated.
  
2. Set up using the docker-compose file:
    ```
    docker compose up -d
    ```

    The app is avaiable on `http://<machine-ip-address>:2283`


## Backup 
The `immich-borg-setup.sh` is used for generating backup of the Immich database and media to a local backup location. More info here https://docs.immich.app/guides/template-backup-script/.

`immich-remote-backup.sh` is used to do the same but to a remote Windows PC via SMB. Make sure to set up the SMB sharing correctly, so that your server can access the folder on the remote machine. Also remember to set up the mountpoint in `/etc/fstab`.

For the home assistant notifications to work, adjust the `HA_URL` and `HA_TOKEN` of both scripts.

I run both scripts as cron jobs.