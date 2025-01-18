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