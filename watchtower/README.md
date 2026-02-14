# Watchtower
[Watchtower](https://github.com/nicholas-fedor/watchtower/) is a tool that can be used to get notified when any of the running docker images has an update available. I set it up to send me notifications via [Home Assistant](homeassistant).

## Installation
1. Edit the `docker-compose.yml`: 
    - In the `WATCHTOWER_NOTIFICATION_URL` change to URL to match your `<machine-ip-address>`.

2. In Home Assistant add a new automation (edit `notify.your_phone_entity_name` to match your device):
```
alias: Watchtower update detected
trigger:
  - platform: webhook
    webhook_id: watchtower_update
action:
  - service: notify.your_phone_entity_name
    data:
      title: "Docker update"
      message: >
        Update available: {{ trigger.json.container_name }}
mode: single
```

3. Set up using the docker-compose file:
    ```
    docker compose up -d
    ```
