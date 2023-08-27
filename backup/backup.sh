#!/bin/bash
# SL
# ==========================================
# Color
RED='\033[0;31m'
NC='\033[0m'
GREEN='\033[0;32m'
ORANGE='\033[0;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
LIGHT='\033[0;37m'
# ==========================================
# Getting
clear
token=$(cat /etc/token)
id_chat=$(cat /etc/id)
domain=$(cat /etc/xray/domain)
IP=$(wget -qO- ipinfo.io/ip);
date=$(date +"%Y-%m-%d")
time=$(date +'%H:%M:%S')
clear
figlet "Backup"
echo "Mohon Menunggu , Proses Backup sedang berlangsung !!"
rm -rf /root/backup
mkdir /root/backup
cp -r /etc/passwd /backup/
cp -r /etc/group /backup/
cp -r /etc/shadow /backup/
cp -r /etc/gshadow /backup/
cp -r /etc/xray /backup/xray
cp -r /root/nsdomain /backup/nsdomain
cp -r /etc/slowdns /backup/slowdns
cp -r /home/vps/public_html /backup/public_html
cd /root
zip -r $IP-$date.zip backup > /dev/null 2>&1
rclone copy /root/$IP-$date.zip dr:backup/
url=$(rclone link dr:backup/$IP-$date.zip)
id=(`echo $url | grep '^https' | cut -d'=' -f2`)
link="https://drive.google.com/u/4/uc?id=${id}&export=download"

curl -F chat_id="$id_chat" -F document=@"$IP.zip" -F caption="Thank You For Using this Script
Domain : $domain
IP VPS : $IP
Date   : $date
Time   : $time WIB
Link Google : $link" https://api.telegram.org/bot$token/sendDocument &> /dev/null


echo -e "
Detail Backup 
==================================
IP VPS        : $IP
Link Backup   : $link
Tanggal       : $date
==================================
" | mail -s "Backup Data" $email
rm -rf /root/backup
rm -rf /root/$IP-$date.zip
clear
echo -e "
Detail Backup 
==================================
IP VPS        : $IP
Link Backup   : $link
Tanggal       : $date
==================================
"
echo "Silahkan disave link diatas"
