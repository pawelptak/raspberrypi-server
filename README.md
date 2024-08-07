# Rasberry Pi Server
Self hosting various services on Raspberry Pi 5

# Services
- [immich](#immich)
- [Plex](#plex)
- [Grafana](#grafana)
- [qBittorrent](#qbittorrent)
- [Nextcloud](#nextcloud)
- [Pi-hole](#pi-hole)

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

# Plex
[Plex Media Server](https://www.plex.tv/personal-media-server/) is a software application that allows you to organize and stream your multimedia to other devices.
## Installation
Install using snap: https://snapcraft.io/install/plexmediaserver/raspbian

The app is available on `http://<machine-ip-address>:32400/manage`. Point the multimedia location using the web interface.

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

# Grafana
[Grafana](https://github.com/grafana/grafana) is a data visualization app. Used to monitor various metrics of the RaspberryPi.

## Installation
1. Edit the docker-compose file from the `prometheus` directory:
    - Set `QBITTORRENT_PASSWORD` with your password for qbittorrent-nox.
    - Set `QBITTORRENT_BASE_URL` to be `http://<machine-ip-address>:8081`.

2. Set up a [prometheus](https://prometheus.io/) database with [Node exporter](https://github.com/prometheus/node_exporter), [cAdvisor](https://github.com/google/cadvisor) and [qbittorrent-exporter](https://github.com/caseyscarborough/qbittorrent-exporter) for various OS metrics. Run the docker-compose file from the `prometheus` directory:
    ```
    docker compose up -d
    ```
    _(This docker compose file uses cAdvisor image `gcr.io/cadvisor/cadvisor:v0.49.1`. It's recommended to replace the version number with the lastest available from https://github.com/google/cadvisor/releases)_

3. Run the Grafana docker container
    ```
    docker run -d -p 3000:3000 --name=grafana grafana/grafana-enterprise
    ```
    The app is avaiable on `http://<machine-ip-address>:3000`

4. Connect the prometheus database to Grafana:
    - In the Grafana web interface go to `Connections` and add a new one with the address `http://<machine-ip-address>:9090`.

5. Create the data dashboard:
    - In the Grafana web interface go to `Dashboards` > `New` > `Import` and upload the JSON file form the `grafana` directory.

    _(For the "SSD Storage" visualizations you might need to adjust the queries used to retrieve the data. For that edit a specific dashboard element and adjust the `mountpoint` and `device` values of each query according to your setup.)_ 

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

# Pi-hole
[Pi-hole](https://github.com/pi-hole/pi-hole) is a network-wide ad blocker.

## Installation
1. Edit the `docker_run.sh` from the `pihole` directory: 
    - Set `FTLCONF_LOCAL_IPV4` with the IP address of your Raspberry Pi.

2. Run the `docker_run.sh` script:
    ```
    bash docker_run.sh
    ```
    The app is avaiable on `http://<machine-ip-address>`

3. Copy the password that is shown in the console output.

4. Enter the password in the web interface.

5. (Optional) Add more adlists by pasting their URLs in the `Adlists` tab. Some Polish ones can be found here: https://www.certyficate.it/polskie-filtry-pi-hole-blokowanie-reklam/.

6. Set the DNS address for your client devices to be the IP address of your Raspberry Pi:
    - Either set it up in your router settings (not possible for me),
    - or set it up in your Wi-Fi network settings on your client device.

7. To have the ad blocking working from outside your local network you should probably omit Point 6. of the [PiVPN](#remote-access-from-outside-local-network) installation (haven't tried it).

# Remote access from outside local network
To be able to use all the services remotely [PiVPN](https://www.pivpn.io/) can be used.

## Installation
1. Use the command:
    ```
    curl -L https://install.pivpn.io | bash
    ```
    and an installation wizard will show up.

2. When being asked whether to use Wireguard or OpenVPN I chose the latter because Wireguard did not work for me.
3. When asked whether the devices will connect via my public IP or a custom DNS **I chose the first option even though I have a custom domain.** The second option did not work for me. Regardless, the custom DNS will be configured later on.
4. After the installation has finished add a new client by typing the command: `pivpn add`. Then choose a name for the client, leave the certificate expiry date as it is, and set a password. A `.ovpn` file will be created in `/home/<username>/ovpns`.
5. For the custom DNS to work open the output `.ovpn` file and replace the IP address in the line `remote <IP address> 1194` with your custom DNS.
6. To make all connections that are not destined to the Raspberry Pi not go through the VPN add the following lines after the line `verb 3`:
    ```
    route-nopull
    route 192.168.1.0 255.255.255.0 vpn_gateway
    ```
    (replace `192.168.1.0` with the address of your network if it differs)

    Otherwise, all connections from the client device will go through the Raspberry Pi when VPN enabled.

7. Securely move the `.ovpn` file to the client device and import it to the OpenVPN app.
