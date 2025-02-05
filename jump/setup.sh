#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

# install goose
sudo apt-get install golang-go
curl -fsSL \
  https://raw.githubusercontent.com/pressly/goose/master/install.sh |\
  sh 

# find the correct volume id (ex: scsi-0DO_Volume_postgres-jump-data)
VOLUME_ID=$(ls /dev/disk/by-id/)

# format and mount
sudo mkfs.ext4 /dev/disk/by-id/$VOLUME_ID

# Create a mount point for your volume:
mkdir -p /mnt/postgres_jump_data

# Mount your volume at the newly-created mount point:
mount -o discard,defaults /dev/disk/by-id/$VOLUME_ID /mnt/postgres_jump_data

# Change fstab so the volume will be mounted after a reboot
echo /dev/disk/by-id/$VOLUME_ID /mnt/postgres_jump_data ext4 defaults,nofail,discard 0 0 | sudo tee -a /etc/fstab

# copy environment file into volume
cp .env /mnt/postgres_jump_data/.env

# generate ssh key
ssh-keygen -t rsa