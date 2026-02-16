# Diun
[Diun](https://github.com/crazy-max/diun) is a tool that can be used to get notified when any of the running docker images has an update available. I set it up to send me notifications via [Home Assistant](../homeassistant).

## Installation
1. Edit the `diun.yml`: 
    - Change the endpoint URL to match your `<machine-ip-address>`.

2. In Home Assistant add a new automation (edit `notify.your_phone_entity_name` to match your device):
```
alias: Docker update detected (Diun)
description: Notify when new Docker image version detected
triggers:
  - trigger: webhook
    webhook_id: docker_update
actions:
  - action: notify.your_phone_entity_name
    data:
      title: "{{ 'New image version' }}"
      message: >
        {% set image = trigger.json.image %} {% set container =
        trigger.json.metadata.ctn_name | default('') %}

        {% if container %}
          Container **{{ container }}** → {{ image }}
        {% else %}
          Image: {{ image }}
        {% endif %}
      data:
        push:
          thread-id: docker-updates
mode: single

```

3. Set up using the docker-compose file:
    ```
    docker compose up -d
    ```