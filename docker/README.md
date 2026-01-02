# Docker
Running a lot of Docker containers will eventually take up a lot of disk space and since my RaspberryPi uses a 32GB SD card, I changed the default Docker config.

```
sudo systemctl stop docker
sudo nano /etc/docker/daemon.json
```

Paste in the contents of `deamon.json` from this directory.

```
sudo systemctl start docker
```

This will change Docker's default config data path (`/var/lib/docker`) and reduce the log size.

Now running the command:

```
docker info | grep "Docker Root Dir"
```
should point to the path defined in `deamon.json`.
