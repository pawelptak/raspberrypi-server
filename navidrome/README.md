# Navidrome
[Navidrome](https://github.com/navidrome/navidrome) is a self-hosted music streaming service.

## Installation
1. Set up using the docker-compose file inside the `navidrome` directory:
    ```
    docker compose up -d
    ```
    (Under `volumes`, `/mnt/ssd/navidrome/data` and `/mnt/ssd/navidrome/music` should point to your music and data folders. `ND_BASEURL` can be omitted if no reverse-proxy will be configured.)

    The app is avaiable on `http://<machine-ip-address>:4533`