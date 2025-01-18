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

1. Install [certbot](https://certbot.eff.org/):
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

## (Optional) Change Apache2 default access log retention policy
By default Apache logs the users that access your server in `/var/log/apache2` in the file that start with `access.log`. By default it logs daily traffic and after each day creates a new log file, while keeping 14 such files max. This behavour can be modified in `/etc/logrotate.d/apache2`. I changed it to log `weekly` and keep `4` files.

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

1. Edit the docker-compose file from the `loki` directory. Change the `/mnt/ssd/GeoLite2_db` path to match the folder that contains your GeoLite2-City database file (My db link can be found [here](../goaccess/README.md)).

2. Set up loki and promtail using the docker-compose file:
    ```
    docker compose up -d
    ```

3. Go to Grafana (`http://<machine-ip-address>:3000`) > `Data sources`. And add the loki database that is under `http://<machine-ip-address>:3100`.

4. Import the dashboards to Grafana by using .json files from the `grafana` directory OR in your dashboard create a new panel with loki as the data source and pass the following query: `{job="modsec"} |~ "ModSecurity: (Warning|Emergency|Alert|Critical)"`. Select the "Logs" dashboard type. This dashboard will allow you to monitor any suspucious traffic on you Apache2 server.

5. Import the alert rule to Grafana by using the `Apache_Alert_Rules.json` file from the `grafana` directory OR in Grafana go to `Alert rules` > `New alert rule`. 
    - Set a name for the rule.
    - Under queries select `Code` and paste the following query: `sum by (ip, message)(count_over_time({job="modsec"} |~ "ModSecurity: (Warning|Emergency|Alert|Critical)" | pattern "<_> [<_> <_>] [<_> <_>] [<_> <_>] [<_> <ip>] <message>" [5m]))`.
    - Under `Expressions` > `Threshold`, select `Input A IS ABOVE 0`.
    - Under `3. Set evaluation behavior` create a folder and evaluation group with the names of your liking. Pending period can be set to 1m. Also set the "no data and error handling" to maintain alert state "OK" when there is no data.
    - Under `5. Add annotations` you can set some summary for your alert which will be seen in the notification message.
    - Save the alert rule.

6. In Grafana go to `Contact points` > `Notification Templates` > `Add notification template`. Paste in the contents of `Apache_Logs_Notification_Template.txt` from the `grafana` directory and save the changes.

7. In Grafana go to `Contact points` > `Add contact point`. I created a Telegram contact point. Configuring it is pretty straightforward, just start with https://t.me/botfather. In the `Message` field use the name from the notification template: `{{ template "warning-alert" . -}}`. Under `Notification settings` I checked the box to not fire the alert on "resolved" state.

8. In Grafana go to `Notification policies` and create or edit the Default policy to point to the contact point created in the previous step. After that you will receive notifications about suspicious traffic on your Apache2 server.