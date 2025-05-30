# Pi-hole
[Pi-hole](https://github.com/pi-hole/pi-hole) is a network-wide ad blocker.

## Installation
1. Edit the `docker_run.sh` from the `pihole` directory: 
    - Set `FTLCONF_LOCAL_IPV4` with the IP address of your Raspberry Pi.

2. Run the `docker_run.sh` script:
    ```
    bash docker_run.sh
    ```
    The app is avaiable on `http://<machine-ip-address>:2137`

3. Copy the password that is shown in the console output.

4. Enter the password in the web interface.

5. (Optional) Add more adlists by pasting their URLs in the `Adlists` tab. Some Polish ones can be found here: https://www.certyficate.it/polskie-filtry-pi-hole-blokowanie-reklam/.

6. Set the DNS address for your client devices to be the IP address of your Raspberry Pi:
    - Either set it up in your router settings (not possible for me),
    - or set it up in your Wi-Fi network settings on your client device.

7. To have the ad blocking working from outside your local network you should probably omit Point 6. of the [PiVPN](../README.md#remote-access-from-outside-local-network) installation (haven't tried it).
8. (Optional) Edit the pihole config to set the log retention time:
    ```
    sudo nano etc-pihole/pihole-FTL.conf
    ```
    Add the following line: `MAXDBDAYS=1` and save the changes. Then `docker restart pihole`.
