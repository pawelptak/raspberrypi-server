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

`immich-remote-backup.sh` is used to do the same but to a remote Windows PC via SSH. Make sure to set up the SSH connection correctly: create a key pair, move the public key onto the WSL machine, set up port forwarding to access WSL (https://learn.arm.com/learning-paths/laptops-and-desktops/wsl2/ssh/).

I run both scripts as cron jobs.