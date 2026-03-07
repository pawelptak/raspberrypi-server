# Jellyfin
[Jellyfin](https://github.com/jellyfin/jellyfin) is an application that allows you to organize and stream your multimedia to other devices.

## Installation
1. In the `docker-compose.yml` file adjust the paths to match your movies and shows locations.

2. Set up using the docker-compose file:
    ```
    docker compose up -d
    ```

    The app is avaiable on `http://<machine-ip-address>:8096`

3. Create a account for logging in.

4. Set up your movie and shows libraries to point to the correct locations.


> **_PRO TIP:_**  The LGs webOS version of the Jellyfin client is crap. The Google TV one is much better.
