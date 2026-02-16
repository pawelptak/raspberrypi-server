# Radarr
[Radarr](https://github.com/Radarr/Radarr) is a tool to automatically search for movie torrents. Also added [Sonarr](https://github.com/Sonarr/Sonarr) which is the same but for TV shows. [Bazarr](https://github.com/morpheus65535/bazarr) is used for automatic subtitle handling. And finally [Overserr](https://github.com/sct/overseerr) as an interface for them both.

## Installation
1. Edit the `docker-compose.yml`: 
    - Change all the occurrences of `/mnt/ssd_plex/content` with your preferred location for the downloaded files.

2. Set up using the docker-compose file:
    ```
    docker compose up -d
    ```
	
### Prowlarr
1. Go to the Prowlarr web interface under `http://<machine-ip-address>:9696`.

2. Under `Settings` > `Indexers` add FlareSolverr. Put `http://<machine-ip-address>:8191` as the address and put in a tag, e.g. `flare`.

3. Under `Settings` > `Apps` configure Radarr and Sonnar connections (the API key of both can be found under `Settings` > `General` of the particular app).

4. Press `Indexers` > `Add Indexer` and add prefered indexers (in my case: 1337x, The Pirate Bay, BitSearch, YTS, LimeTorrents). Some indexers require FlareSolverr to connect succesfully - in that case add the previously defined `flare` tag to such indexer (1337x requires it).

### Radarr
1. Go to the Radarr web interface under `http://<machine-ip-address>:9117`.

2. Under `Settings` > `Media Management` select `Add Root Folder` and select the `movies` folder.

3. After setting up the indexers you can limit the max file size here under `Maximum Size`. I set it to `51200` MB.

4. Under `Settings` > `Download Clients` add a new one and select `qBittorrent`. Under `Host` type in your `<machine-ip-address>`. Port is `8081` for me. Also fill in the qBittorrent username and password and save the changes.

### Sonarr
1. Go to the Sonarr web interface under `http://<machine-ip-address>:8989`.

2. Under `Settings` > `Media Management` select `Add Root Folder` and select the `shows` folder.

3. Under `Settings` > `Download Clients` add a new one and select `qBittorrent`. Under `Host` type in your `<machine-ip-address>`. Port is `8081` for me. Also fill in the qBittorrent username and password and save the changes.

### Overseerr
1. Go to the Overseerr web interface under `http://<machine-ip-address>:5055`.

2. Select `Sign in with Plex`, sign in with your Plex account and configure the connection to your Plex server.

3. Configure Radarr and Sonarr connections.


### Bazarr
1. Go to the Bazarr web interface under `http://<machine-ip-address>:6767`.

2. Go to `Settings` > `Sonarr` and enable Sonarr. Put it the `machine-ip-address` and the API key (from `Settings` > `General` in Sonar).

3. Go to `Settings` > `Radarr` and enable Radarr. Put it the `machine-ip-address` and the API key (from `Settings` > `General` in Radarr).

4. Go to `Settings` > `Plex` and connect to your Plex.

5. Go to `Settings` > `Languages`. Put in some language filters, e.g. `Polish`. Add a language profile and select the preferred language.

6. Go to `Settings` > `Providers` and add some subtitle providers (some of them may lequire authentication). I chose: Napisy24, Napiprojekt, Opensubtitles.com, Subdl, Supersubtitles, TVSubtitles, YIFY Subtitles, Podnapisi, subf2m.co, Gestdown (Addic7ed proxy).
