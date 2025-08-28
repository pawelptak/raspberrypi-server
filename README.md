```
sudo nano /etc/samba/smb.conf

[raspberrypi]
path=/home/raspberrypi
browsable=yes
writeable=yes
create mask=0777
directory mask=0777

[webfolder]
path=/mnt/woodenpc
guest ok = yes
guest only = yes
read only = no

# the main ssd
[shared_ssd]
path = /mnt/ssd
browseable = yes
writeable = yes
only guest = no
create mask = 0777
directory mask = 0777
public = no

# the backup ssd
[shared_ssd_backup]
path = /mnt/ssd_backup
browseable = yes
writeable = yes

# the plex ssd
[ssd_plex]
path = /mnt/ssd_plex
browseable = yes
writeable = yes
only guest = no
create mask = 0777
directory mask = 0777
public = no
```
