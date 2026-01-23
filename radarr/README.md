# Radarr
[Radarr](https://github.com/Radarr/Radarr) a tool to automatically search for movie torrents. Also added [Sonarr](https://github.com/Sonarr/Sonarr) which is the same but for TV shows. And finally [Overserr](https://github.com/sct/overseerr) as an interface for them both.

## Installation
1. Edit the `docker-compose.yml`: 
    - Change all the occurrences of `/mnt/ssd_plex/content` with your preferred location for the downloaded files.

2. Set up using the docker-compose file:
    ```
    docker compose up -d
    ```

3. Set correct permissions for Radarr:
```
sudo chown -R 1000:1000 /mnt/ssd_plex/movies
sudo chmod -R 775 /mnt/ssd_plex/movies
```

4. Go to the Jackett web interface under `http://<machine-ip-address>:9117`.

5. Press `Add indexer` and add prefered indexers (in my case: 1337x, The Pirate Bay, TheRARBG, YTS).

6. Under `Jackett Configuration` set the `FlareSolverr API URL` to `http://<machine-ip-address>:8191` (this is needed for the connection to 1337x and YTS to work). Apply the changes.

7. Go to the Radarr web interface under `http://<machine-ip-address>:9117`.

8. Under `Settings` > `Media Management` select `Add Root Folder` and select the `movies` folder.

9. Under `Settings` > `Indexers` add a new one and select `Torznab`, then go back to Jackett and for each indexer press the `Copy Torznab Feed` button, paste it into Radarr. Also copy the API key from Jackett.

10. After setting up the indexers you can limit the max file size here under `Maximum Size`. I set it to `51200` MB.

11. Under `Settings` > `Download Clients` add a new one and select `qBittorrent`. Under `Host` type in your `<machine-ip-address>`. Port is `8081` for me. Also fill in the qBittorrent username and password and save the changes.

12. Go to the Sonarr web interface under `http://<machine-ip-address>:8989`.

13. Under `Settings` > `Media Management` select `Add Root Folder` and select the `tv` folder.

14. Under `Settings` > `Indexers` add a new one and select `Torznab`, then go back to Jackett and for each indexer press the `Copy Torznab Feed` button, paste it into Sonarr. Also copy the API key from Jackett (YTS can be omitted).

15. Under `Settings` > `Download Clients` add a new one and select `qBittorrent`. Under `Host` type in your `<machine-ip-address>`. Port is `8081` for me. Also fill in the qBittorrent username and password and save the changes.

16. Go to the Overseerr web interface under `http://<machine-ip-address>:5055`.

17. Select `Sign in with Plex`, sign in with your Plex account and configure the connection to your Plex server.

18. Configure Radarr and Sonarr connections.