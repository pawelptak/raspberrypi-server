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