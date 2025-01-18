# PiVPN
[PiVPN](https://www.pivpn.io/) is a script that automates installing a VPN client on RaspberryPi.

## Installation
1. Use the command:
    ```
    curl -L https://install.pivpn.io | bash
    ```
    and an installation wizard will show up.

2. When being asked whether to use Wireguard or OpenVPN I chose the latter because Wireguard did not work for me.
3. When asked whether the devices will connect via my public IP or a custom DNS **I chose the first option even though I have a custom domain.** The second option did not work for me. Regardless, the custom DNS will be configured later on.
4. After the installation has finished add a new client by typing the command: `pivpn add`. Then choose a name for the client, leave the certificate expiry date as it is, and set a password. A `.ovpn` file will be created in `/home/<username>/ovpns`.
5. For the custom DNS to work open the output `.ovpn` file and replace the IP address in the line `remote <IP address> 1194` with your custom DNS.
6. To make all connections that are not destined to the Raspberry Pi not go through the VPN add the following lines after the line `verb 3`:
    ```
    route-nopull
    route 192.168.1.0 255.255.255.0 vpn_gateway
    ```
    (replace `192.168.1.0` with the address of your network if it differs)

    Otherwise, all connections from the client device will go through the Raspberry Pi when VPN enabled.

7. Securely move the `.ovpn` file to the client device and import it to the OpenVPN app.