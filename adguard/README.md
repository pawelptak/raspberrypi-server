# AdGuard Home
[AdGuard Home](https://github.com/AdguardTeam/AdGuardHome) is a network-wide ad blocker.

## Installation
1. Run via `docker-compose.yml`:
    ```
    docker compose up -d
    ```

2. Go to `http://<machine-ip-address>:3001` and go through the configuration (default options are OK).

3. The web interface is available via `http://<machine-ip-address>:8083`.

4. (Optional) Add more ad filters by pasting their URLs in the `Filters` tab under `http://<machine-ip-address>:8083/#custom_rules`. Some Polish ones can be found here: https://majkiit.github.io/polish-ads-filter/.

5. Set the DNS address for your client devices to be the IP address of your Raspberry Pi:
    - Either set it up in your router settings (not possible for me),
    - or set it up in your Wi-Fi network settings on your client device.

6. To have the ad blocking working from outside your local network you should probably omit Point 6. of the [PiVPN](../README.md#remote-access-from-outside-local-network) installation (haven't tried it).