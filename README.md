# Rasberry Pi Server
Self hosting various services on Raspberry Pi 5

# Services
- [immich](#immich)
- [Plex](#plex)
- [Grafana](#grafana)
- [qBittorrent](#qbittorrent)
- [Nextcloud](#nextcloud)
- [Pi-hole](#pi-hole)
- [Apache2](#apache2)
- [GoAccess](#goaccess)
- [ClipYT](#clipyt)
- [Navidrome](#navidrome)

# Prerequisites
- [Docker](https://docs.docker.com/get-docker/)
- [Docker compose](https://docs.docker.com/compose/install/)
- [snap](https://snapcraft.io/docs/installing-snap-on-raspbian)

# Immich
[Immich](https://github.com/immich-app/immich) is a photo and video management solution.
## Installation
1. Edit the `.env` file from the `immich` directory:
    - Set `UPLOAD_LOCATION` with your preferred location for storing files. `/mnt/ssd/immich` in my case.
    - Change `DB_PASSWORD` to something randomly generated.
  
2. Set up using the docker-compose file:
    ```
    docker compose up -d
    ```

    The app is avaiable on `http://<machine-ip-address>:2283`

# Plex
[Plex Media Server](https://www.plex.tv/personal-media-server/) is a software application that allows you to organize and stream your multimedia to other devices.
## Installation
Install using snap: https://snapcraft.io/install/plexmediaserver/raspbian

The app is available on `http://<machine-ip-address>:32400/manage`. Point the multimedia location using the web interface.

# qBittorrent
[qBittorrent](https://github.com/qbittorrent/docker-qbittorrent-nox) is a bittorrent client. I set it up to download multimedia files directly to the Plex library.

## Installation
1. Edit the `.env` from the `qbittorrent` directory: 
    - Set `QBT_DOWNLOADS_PATH` with your preferred location for the downloaded files. `/mnt/ssd/plex` in my case.

2. Set up using the docker-compose file:
    ```
    docker compose up -d
    ```
    The app is avaiable on `http://<machine-ip-address>:8081`

3. Get the web interface login credentials:
    - Run `docker logs qbittorrent-nox` to find the randomly generated password for the `admin` user.
    - Log in to the app using the login `admin` and the password from the logs. You can change the password in the app settings.

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

# Nextcloud
[Nextcloud](https://github.com/nextcloud/server) is a file hosting solution.

## Installation
1. Edit the `.env` from the `nextcloud` directory: 
    - Set `NEXTCLOUD_PATH` with your preferred location for storing your files. `/mnt/ssd/nextcloud` in my case.
    - Set `POSTGRES_PASSWORD` to something randomly generated.

2. Set up using the docker-compose file:
    ```
    docker compose up -d
    ```
    The app is avaiable on `http://<machine-ip-address>:8080`

3. Create your account and set up the database connection:
    - In the web interface create your account by filling out the username and password fields with your preferred values.
    - Under `Configure the database` select `PostgreSQL` and fill out the fields below:
        - Database user: `postgres`.
        - Database password: the one from the `.env` file.
        - Database name: `postgres`
        - Database host: `postgres`

## Access via HTTPS
To do it you have to set up [Apache2 with HTTPS](#enable-https) first.

1. After that, add the following lines to your Apache2 config file (assuming Nextcloud runs on the default 8080 port):
    ```
    ProxyPass / http://localhost:8080/
    ProxyPassReverse / http://localhost:8080/
    ```

2. Edit the Nextcloud `config.php` file (in my case it's under `/mnt/ssd/nextcloud/config/config.php`). 

    - Add your domain to the `'trusted_domains'`. In my case it's:
        ```
            'trusted_domains' => 
        array (
            0 => '192.168.1.21:8080',
            1 => 'karolwojtyla.servecounterstrike.com',
        ),
        ```
    - Edit the `'overwrite.cli.url'` line to point to your domain. In my case: 
        ```
        'overwrite.cli.url' => 'https://karolwojtyla.servecounterstrike.com',
        ```
    - Add the following line:
      ```
      'overwriteprotocol' => 'https',
      ```
    - Add your local IP to the `'trusted_proxies'`. In my case it's:
      ```
      'trusted_proxies' => ['192.168.1.21'],
      ```

3. Restart Apache2 and Nextcloud:
    ```
    sudo systemctl restart apache2
    docker restart nextcloud
    ``` 

4. (Optional but strongly recommended) Enable 2FA in Nextcloud. In the Nextcloud web interface go to Applications and add the `Two-Factor TOTP Provider` app. Then go to your account settings > `Security` > TOTP. Configure it with the Authenticator app.

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

7. To have the ad blocking working from outside your local network you should probably omit Point 6. of the [PiVPN](#remote-access-from-outside-local-network) installation (haven't tried it).

# Apache2
[Apache2](https://httpd.apache.org/) is a HTTP web server.

## Installation
1. Run the following command: 
    ```
    sudo apt install apache2 -y
    ```

2. Start and enable Apache to run at boot:
    ```
    sudo systemctl start apache2
    sudo systemctl enable apache2

    ```
    The app is avaiable on `http://<machine-ip-address>`. You should see the default Apache web page.

## Sharing files on the server

1. Create a directory to hold your files:
    ```
    sudo mkdir /var/www/html/content
    ```

2. Put your files into the directory.

3. Copy the `shared.conf` file from the `apache2` directory into the `/etc/apache2/sites-available` directory.

4. Enable the site:
    ```
    sudo a2ensite shared.conf
    ```

5. Reload Apache:
    ```
    sudo systemctl reload apache2
    ```
    The content placed in `/var/www/html/content` is avaiable on `http://<machine-ip-address>/content`.

## Enable HTTPS
To enable HTTPS you need to have a domain configured. You can get one for free from services like [No-IP](https://www.noip.com/).

1. Install (certbot)[https://certbot.eff.org/]:
    ```
    sudo apt install certbot python3-certbot-apache -y
    ```

2. Obtain and install the SSL certificate:
    ```
    sudo certbot --apache
    ```
    and follow the prompts on the screen. Choose your domain name as well as the `shared` site activated earilier.
   
    (Cert renewal: Make sure NAT for port 80 is enabled for your domain in router settings! And type in `sudo certbot renew`.)

4. A file named `shared-le-ssl.conf` will be generated in `/etc/apache2/sites-available/`.

5. Enable SSL Module and Site:
    ```
    sudo a2enmod ssl
    sudo a2ensite shared-le-ssl.conf
    sudo systemctl reload apache2
    ```
    Your content will be available on `https://<machine-ip-address>/content`.

## (Optional) Secure Apache2 server against attacks
[ModSecurity](https://github.com/owasp-modsecurity/ModSecurity) will be used to secure the Apache2 server against malicious attacks.

1. Install and enable ModSecurity:
    ```
    sudo apt install apache2 libapache2-mod-security2 -y
    sudo a2enmod security2
    sudo systemctl restart apache2
    ```

2. Use the default configuration file:
    ```
    sudo cp /etc/modsecurity/modsecurity.conf-recommended /etc/modsecurity/modsecurity.conf
    ```

3. Install the OWASP ModSecurity Core Rule Set (CRS) (URL to the latest version can be found in https://coreruleset.org/docs/deployment/install/):
    ```
    wget https://github.com/coreruleset/coreruleset/archive/v3.3.0.zip
    unzip v3.3.0.zip
    mv coreruleset-3.3.0/crs-setup.conf.example /etc/modsecurity/crs-setup.conf
    mv coreruleset-3.3.0/rules/ /etc/modsecurity/
    ```

4. Edit your Apache security2.conf file to load ModSecurity rules:
    ```
    sudo nano /etc/apache2/mods-enabled/security2.conf

    <IfModule security2_module>
            # Default Debian dir for modsecurity's persistent data
            SecDataDir /var/cache/modsecurity
    
            # Include all the *.conf files in /etc/modsecurity.
            # Keeping your local configuration in that directory
            # will allow for an easy upgrade of THIS file and
            # make your life easier
            IncludeOptional /etc/modsecurity/*.conf
            Include /etc/modsecurity/rules/*.conf
    
            # Disable rules that block Nextcloud access (Rule 200002 specifically breaks file uploading)
            SecRuleRemoveById 980120
            SecRuleRemoveById 980130
            SecRuleRemoveById 911100
            SecRuleRemoveById 920350
            SecRuleRemoveById 920300
            SecRuleRemoveById 949110
            SecRuleRemoveById 920230
            SecRuleRemoveById 920420
            SecRuleRemoveById 200002       
    
            # Maximum size of POST data 5 GB
            SecRequestBodyLimit 5368709120 
            
            # Maximum size for requests without files 5 GB   
            SecRequestBodyNoFilesLimit 5368709120
    
            # Maximum in memory data 1 MB
            SecRequestBodyInMemoryLimit 1048576
        
            # Include OWASP ModSecurity CRS rules if installed
            #IncludeOptional /usr/share/modsecurity-crs/*.load
    </IfModule>
    ```
5. (Optional) Enable DoS Protection. Edit the `/etc/modsecurity/crs-setup.conf` and find the `[[ Anti-Automation / DoS Protection ]]` section. The default is blocking more than 100 requests in 60 seconds for 600 seconds. Uncomment the rule below and adjust the values to your liking.

6. Switch ModSecurity to blocking mode:
    ```
    sudo nano /etc/modsecurity/modsecurity.conf
    ```
    Change the line `SecRuleEngine DetectionOnly` to `SecRuleEngine On` and save the changes.

7. Restart Apache2:
    ```
    systemctl restart apache2
    ```
    If you get errors about duplicated rules, ensure you have only one `crs-setup.conf`. I had to remove the one from `/etc/modsecurity/crs`.

### (Optional) Configure Grafana monitoring of ModSecurity logs
Loki and Promtail have been used to fetch logs from ModSecurity and pass them to Grafana to create a panel showing suspicious traffic and send nofications alerting about it.

1. Edit the docker-compose file from the `loki` directory. Change the `/mnt/ssd/GeoLite2_db` path to match the folder that contains your GeoLite2-City database file (I got mine from https://github.com/P3TERX/GeoLite.mmdb).

2. Set up loki and promtail using the docker-compose file:
    ```
    docker compose up -d
    ```

3. Go to Grafana (`http://<machine-ip-address>:3000`) > `Data sources`. And add the loki database that is under `http://<machine-ip-address>:3100`.

4. Import the dashboards to Grafana by using .json files from the `grafana` directory OR in your dashboard create a new panel with loki as the data source and pass the following query: `{job="modsec"} |~ "ModSecurity: (Warning|Emergency|Alert|Critical)"`. Select the "Logs" dashboard type. This dashboard will allow you to monitor any suspucious traffic on you Apache2 server.

5. Import the alert rule to Grafana by using .json file from the `grafana` directory OR in Grafana go to `Alert rules` > `New alert rule`. 
    - Set a name for the rule.
    - Under queries select `Code` and paste the following query: `sum by (ip, message)(count_over_time({job="modsec"} |~ "ModSecurity: (Warning|Emergency|Alert|Critical)" | pattern "<_> [<_> <_>] [<_> <_>] [<_> <_>] [<_> <ip>] <message>" [5m]))`.
    - Under `Expressions` > `Threshold`, select `Input A IS ABOVE 0`.
    - Under `3. Set evaluation behavior` create a folder and evaluation group with the names of your liking. Pending period can be set to 1m. Also set the "no data and error handling" to maintain alert state "OK" when there is no data.
    - Under `5. Add annotations` you can set some summary for your alert which will be seen in the notification message.
    - Save the alert rule.

6. In Grafana go to `Contact points` > `Notification Templates` > `Add notification template`. Paste in the contents of `Apache_Logs_Notification_Template.txt` from the `grafana` directory and save the changes.

7. In Grafana go to `Contact points` > `Add contact point`. I created a Telegram contact point. Configuring it is pretty straightforward, just start with https://t.me/botfather. In the `Message` field use the name from the notification template: `{{ template "warning-alert" . -}}`. Under `Notification settings` I checked the box to not fire the alert on "resolved" state.

8. In Grafana go to `Notification policies` and create or edit the Default policy to point to the contact point created in the previous step. After that you will receive notifications about suspicious traffic on your Apache2 server.

# GoAccess
[GoAccess](https://goaccess.io/) is a web log analyzer that allows you to analyze the trafic from your server trough the web browser. In this case it is used to analyze Apache2 server logs.

## Installation
1. Download a GeoIp database. I used the GeoLite2-City database downloaded from https://github.com/P3TERX/GeoLite.mmdb.

2. Edit the docker-compose file from the `goaccess` directory: 
    - Under `volumes` set the correct path to point to the GeoLite2-City database.

3. Run the containers using the docker-compose:
    ```
    docker compose up -d
    ```
    The app is avaiable on `http://<machine-ip-address>:7891/report.html`

# ClipYT
[ClipYT](https://github.com/pawelptak/clip-yt) is a web app for downloading and clipping YouTube videos.

## Installation
1. Set up using the docker-compose file inside the `clipyt` directory:
    ```
    docker compose up -d
    ```
    The app is avaiable on `http://<machine-ip-address>:2138`


# Navidrome
[Navidrome](https://github.com/navidrome/navidrome) is a self-hosted music streaming service.

## Installation
1. Set up using the docker-compose file inside the `navidrome` directory:
    ```
    docker compose up -d
    ```
    (Under `volumes`, `/mnt/ssd/navidrome/data` and `/mnt/ssd/navidrome/music` should point to your music and data folders. `ND_BASEURL` can be omitted if no reverse-proxy will be configured.)

    The app is avaiable on `http://<machine-ip-address>:4533`
    

# Remote access from outside local network
To be able to use all the services remotely [PiVPN](https://www.pivpn.io/) can be used.

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

# Data backup

## Nextcloud (or any other folder)

1. Install rsync:
    ```
    sudo apt install rsync
    ```

2. (optional) Run rsync manually:
    ```
    sudo rsync -av --delete /home/pi/myfolder/ /mnt/backupdrive/mybackup/
    ```
    (The nextcloud data folder will be something like `.../nextcloud/data/admin/files`)

3. Set up a cron job for automation. Edit the crontab file:
    ```
    sudo crontab -e
    ```
And add the following line (this will run daily at 3:00 AM):

`0 3 * * * rsync -av --delete /home/pi/myfolder/ /mnt/backupdrive/mybackup/`

More info on the cron syntax [here](https://crontab.guru/).

## Immich
In the `immich` folder you got the .env file and there: `UPLOAD_LOCATION` with all the photos and `DB_DATA_LOCATION` that has the paths to the photos. Both have to be backuped. The database is automatically backuped in `UPLOAD_LOCATION\backups` ([source](https://immich.app/docs/administration/backup-and-restore/#automatic-database-backups)). To create a backup of Immich db and the media files on a separate drive, you need to perform the following steps:

1. Install Borg: 
    ```
    sudo apt install borgbackup
    ```

2. Run the commands from the "Borg set-up" section of the [docs](https://immich.app/docs/guides/template-backup-script/) (I omit the "##Remote set up" part. Add `sudo` for commands that fail).

3. Edit and run the script from the "Borg backup template" section of the [docs](https://immich.app/docs/guides/template-backup-script/) (Again, I omit the "REMOTE_HOST", "REMOTE_BACKUP_PATH" lines and the "### Append to remote Borg repository" section). The script that I used can be found in `data-backup/immich-borg-setup.sh`. Running the script can take a while, since it is creating backup of all the data.

4. Edit the crontab file:
    ```
    sudo crontab -e
    ```
    Add the following line (this will run daily at 2:00 AM):

    `0 2 * * * /path/to/your/immich-borg-setup.sh`

5. Make the script executable:
    ```
    sudo chmod +x immich-borg-setup.sh
    ```

6. (optional) If everything works you can disable Immich automatic database backup by going to `http://your-immich-address/admin/system-settings` and unchecking the automatic database backup option.

7. To restore data from a certain point, refer to the [restoring](https://immich.app/docs/guides/template-backup-script/#restoring) section. You restored data will be in the temporary mountpoint that you create. After restoring the data, unmount the mountpoint.

For restoring the immich database itself, keep in mind the [Manual Backup and Restore](https://immich.app/docs/administration/backup-and-restore/#manual-backup-and-restore) section of the docs (The "Restore" part). They mention a `dump.sql.gz` file but we have just a .sql file backed up, so idk? Good luck and may God be with you when doing the restore part.

