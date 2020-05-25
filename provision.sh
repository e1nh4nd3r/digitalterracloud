#!/bin/bash

# Set a sleep action so that the instance has time to boot fully
## TODO: Maybe not necessary?
# sleep 60

# apt update all the things
apt update && apt dist-upgrade -y && apt autoclean -y

# apt install some packages
apt install -y net-tools

# install the nextcloud snap
snap install nextcloud

# reboot container to apply latest kernel
shutdown -r now

# install docker
# curl -sSL https://get.docker.com/ubuntu/ | sudo sh

# print docker version
# docker version