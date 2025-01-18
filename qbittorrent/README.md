# qBittorrent
[qBittorrent](https://github.com/qbittorrent/docker-qbittorrent-nox) is a bittorrent client. I set it up to download multimedia files directly to the Plex library.

## Installation
1. Edit the `.env` from the `qbittorrent` directory: 
    - Set `QBT_DOWNLOADS_PATH` with your preferred location for the downloaded files. `/mnt/ssd/plex` in my case.

2. Set up using the docker-compose file:
    ```
    docker compose up -d
    ```
    The app is avaiable on `http://<machine-ip-address>:8081`

3. Get the web interface login credentials:
    - Run `docker logs qbittorrent-nox` to find the randomly generated password for the `admin` user.
    - Log in to the app using the login `admin` and the password from the logs. You can change the password in the app settings.