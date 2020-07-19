#!/bin/sh
ip_address=$(ip route get 8.8.8.8 | sed -n '/src/{s/.*src *\([^ ]*\).*/\1/p;q}')
echo $ip_address
stripped_last_octet=`echo $ip_address | cut -d"." -f1-3`
echo $stripped_last_octet
subnet=$stripped_last_octet".0"
echo $subnet
sudo nmap $subnet/24
