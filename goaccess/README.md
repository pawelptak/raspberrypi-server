# GoAccess
[GoAccess](https://goaccess.io/) is a web log analyzer that allows you to analyze the trafic from your server trough the web browser. In this case it is used to analyze Apache2 server logs.

## Installation
1. Download a GeoIp database. I used the GeoLite2-City database downloaded from https://github.com/P3TERX/GeoLite.mmdb.

2. Edit the docker-compose file from the `goaccess` directory: 
    - Under `volumes` set the correct path to point to the GeoLite2-City database.

3. Run the containers using the docker-compose:
    ```
    docker compose up -d
    ```
    The app is avaiable on `http://<machine-ip-address>:7891/report.html`