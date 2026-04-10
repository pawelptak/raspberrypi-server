```
sudo cat /etc/fstab
proc            /proc           proc    defaults          0       0
PARTUUID=06b7cd34-01  /boot/firmware  vfat    defaults          0       2
PARTUUID=06b7cd34-02  /               ext4    defaults,noatime  0       1
UUID=b8ecf103-b3d7-45fc-99b0-8cf127453966 /mnt/ssd        ext4 defaults,nofail,x-systemd.device-timeout=5s 0 2
UUID=17d72394-d6f6-40a6-94a8-876f38bfb388 /mnt/ssd_backup ext4 defaults,nofail,x-systemd.device-timeout=5s 0 2
UUID=674b4b91-8aa9-475a-a891-301d6e929bc2  /mnt/ssd_plex  ext4  defaults,nofail,x-systemd.device-timeout=5s 0 2

# Windows SMB backup share
//192.168.1.29/backups_from_raspberry /mnt/backup_on_windows cifs username=twojstary,vers=3.0,nofail,x-systemd.automount,_netdev 0 0

# a swapfile is not a swap partition, no line here
#   use  dphys-swapfile swap[on|off]  for that
/mnt/ssd/swapfile none swap sw 0 0 # I moved my swap onto an external SSD
```

