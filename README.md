# Space cleanup commands
`ncdu` -- check disk space

`docker system prune -a` -- clean unused docker data

`sudo sh -c "truncate -s 0 /var/lib/docker/containers/*/*-json.log"` -- clean docker logs

`sudo apt-get clean`

`sudo bash -c 'rm /var/lib/snapd/cache/*'` -- clean snap cache

Set journal logs max size: https://unix.stackexchange.com/a/130802

`sudo journalctl --vacuum-size=500M` -- clean journal log size to have max 500M

`truncate -s 0 /home/raspberrypi/ApkiPawla/pihole/etc-pihole/pihole-FTL.db` - clean pihole logs
