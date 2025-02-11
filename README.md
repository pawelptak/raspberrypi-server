# Space cleanup commands
`ncdu` -- check disk space

`docker system prune -a` -- clean unused docker data

`sudo sh -c "truncate -s 0 /var/lib/docker/containers/*/*-json.log"` -- clean docker logs

`sudo apt-get clean`

`sudo bash -c 'rm /var/lib/snapd/cache/*'` -- clean snap cache
