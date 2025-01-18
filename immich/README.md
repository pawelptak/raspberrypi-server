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