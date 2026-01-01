# Plex
[Plex Media Server](https://www.plex.tv/personal-media-server/) is a software application that allows you to organize and stream your multimedia to other devices.
## Installation
Install using snap: https://snapcraft.io/install/plexmediaserver/raspbian

The app is available on `http://<machine-ip-address>:32400/manage`. Point the multimedia location using the web interface.

Additionaly, doing: 
```
sudo snap set system refresh.retain=2
```
will save you some space.
