# Rasberry Pi Server
Self hosting various services on Raspberry Pi 5

# Services
- [immich](#immich)
- [Plex](#plex)
- [Grafana](#grafana)
- [qBittorrent](#qbittorrent)

# Prerequisites
- [Docker](https://docs.docker.com/get-docker/)
- [Docker compose](https://docs.docker.com/compose/install/)
- [snap](https://snapcraft.io/docs/installing-snap-on-raspbian)

# Immich
[Immich](https://github.com/immich-app/immich) is a photo and video management solution.
## Installation
1. Edit the `.env` file:
    - Set `UPLOAD_LOCATION` with your preferred location for storing files. `/mnt/ssd/` in my case.
    - Change `DB_PASSWORD` to something randomly generated.
  
Set up using the following docker-compose file: TODO
```
docker compose up -d
```

The app is avaiable on `http://<machine-ip-address>:2283`

# Grafana

# Plex

# qBittorrent

# TODO: Nextcloud
