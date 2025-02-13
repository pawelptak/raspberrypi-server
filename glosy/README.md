# Glosy
[Glosy](https://github.com/pawelptak/glosy) is a web voice conversion tool.

## Installation
1. Edit the docker-compose file inside the `glosy` directory:
    Edit the `/mnt/ssd/tts_models` path to point to a location of your liking. In my case I pointed an external SSD, since the models can weight a couple of GBs. Save the changes.              

2. Set up using the docker-compose file:
    ```
    docker compose up -d
    ```
    The app is avaiable on `http://<machine-ip-address>:2139`