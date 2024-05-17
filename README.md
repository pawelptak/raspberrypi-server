# Rasberry Pi Server
Self hosting various services on Raspberry Pi 5

# Services
- [immich](#immich)
- [Plex](#plex)
- [Grafana](#grafana)
- [qBittorrent](#qbittorrent)
- [Nextcloud](#nextcloud)

# Prerequisites
- [Docker](https://docs.docker.com/get-docker/)
- [Docker compose](https://docs.docker.com/compose/install/)
- [snap](https://snapcraft.io/docs/installing-snap-on-raspbian)

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

# Grafana
[Grafana](https://github.com/grafana/grafana) is a data visualization app. Used to monitor various metrics of the RaspberryPi.

## Installation
1. Set up a [prometheus](https://prometheus.io/) database with [Node exporter](https://github.com/prometheus/node_exporter) for OS metrics. Run the following docker-compose file from the `prometheus` directory:
```
docker compose up -d
```

2. Run the Grafana docker container
```
docker run -d -p 3000:3000 --name=grafana grafana/grafana-enterprise
```
The app is avaiable on `http://<machine-ip-address>:3000`

3. Connect the prometheus database to Grafana:
    - In the Grafana web interface go to `Connections` and add a new one with the address `http://<machine-ip-address>:9090`.
4. Create the data dashboard:
    - In the Grafana web interface go to `Dashboards` > `New` > `Import` and upload the following JSON file: TODO.

    _(For the "SSD Storage" visualizations you might need to adjust the queries used to retrieve the data. For that edit a specific dashboard element and adjust the `mountpoint` and `device` values of each query according to your setup.)_ 

# Plex
[Plex Media Server](https://www.plex.tv/personal-media-server/) is a software application that allows you to organize and stream your multimedia to other devices.
## Installation
Install using snap: https://snapcraft.io/install/plexmediaserver/raspbian

The app is avaiable on `http://<machine-ip-address>:32400`. Point the multimedia location using the web interface.

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

# Nextcloud
[Nextcloud](https://github.com/nextcloud/server) is a file hosting solution.

## Installation
1. Edit the `.env` from the `nextcloud` directory: 
    - Set `NEXTCLOUD_PATH` with your preferred location for storing your files. `/mnt/ssd/nextcloud` in my case.
    - Set `POSTGRES_PASSWORD` to something randomly generated.

2. Set up using the docker-compose file:
```
docker compose up -d
```
The app is avaiable on `http://<machine-ip-address>:8080`

3. Create your account and set up the database connection:
    - In the web interface create your account by filling out the username and password fields with your preferred values.
    - Under `Configure the database` select `PostgreSQL` and fill out the fields below:
        - Database user: `postgres`.
        - Database password: the one from the `.env` file.
        - Database name: `postgres`
        - Database host: `postgres`
