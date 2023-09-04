#!/bin/sh
sudo apt update
sudo apt upgrade -y
sudo apt install openjdk-8-jre-headless htop nodejs docker net-tools -y

adduser dennis
usermod -aG sudo dennis

cd /opt
wget https://download.sonatype.com/nexus/3/latest-unix.tar.gz
tar -zxvf latest-unix.tar.gz

adduser nexus
chown -R nexus:nexus nexus-3.42.0-01
chown -R nexus:nexus sonatype-work

vim nexus-3.42.0-01/bin/nexus.rc
run_as_user="nexus"

su - nexus
/opt/nexus-3.42.0-01/bin/nexus start

ps aux | grep nexus
netstat -lnpt