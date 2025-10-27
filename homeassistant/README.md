# Home Assistant
[Home Assistant](https://www.home-assistant.io/) is a home automation service.

## Installation
1. Set up using the docker-compose file inside the `homeassistant` directory:
    ```
    docker compose up -d
    ```

    The app is avaiable on `http://<machine-ip-address>:8123`

## Data backup
Set up automatic data backup. 

1. From the Home Assistant UI, go to `Settings` -> `System` -> `Backups`.
2. In the `Backup settings` tab set up an automatic backup with the frequency of your choice (e.g. daily with data retention set to 2).
