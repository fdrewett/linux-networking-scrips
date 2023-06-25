#!/bin/sh
# ip_address=$(route -n get default | grep interface | awk '{print $2}' | xargs -I {} ifconfig {} | grep "inet " | awk '{print $2}')
# echo $ip_address
# stripped_last_octet=`echo $ip_address | cut -d"." -f1-3`
# echo $stripped_last_octet
# subnet=$stripped_last_octet".0"
# echo $subnet
# echo "----------------------------------------------"
# echo "arp scan results - $subnet"/24
# echo "----------------------------------------------"
# sudo arp-scan $subnet/24
# echo "----------------------------------------------"
# echo "nmap quick scan results - $subnet"/24
# echo "----------------------------------------------"
# sudo nmap -sn $subnet/24
# echo "----------------------------------------------"
# echo "nmap full scan results - $subnet"/24
# echo "----------------------------------------------"
# sudo nmap $subnet/24
# ----------------------------------------------


# Parse command line options
while getopts "s:" opt; do
  case $opt in
    s)
      scan_type=$OPTARG
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      exit 1
      ;;
    :)
      echo "Option -$OPTARG requires an argument." >&2
      exit 1
      ;;
  esac
done

# Set default scan type to arp
if [ -z "$scan_type" ]; then
  scan_type="arp"
fi

# Get IP address and subnet
ip_address=$(route -n get default | grep interface | awk '{print $2}' | xargs -I {} ifconfig {} | grep "inet " | awk '{print $2}')
stripped_last_octet=`echo $ip_address | cut -d"." -f1-3`
subnet=$stripped_last_octet".0"

# Run selected scan
case $scan_type in
  arp)
    echo "----------------------------------------------"
    echo "arp scan results - $subnet/24"
    echo "----------------------------------------------"
    sudo arp-scan $subnet/24
    ;;
  nmap-quick)
    echo "----------------------------------------------"
    echo "nmap quick scan results - $subnet/24"
    echo "----------------------------------------------"
    sudo nmap -sn $subnet/24
    ;;
  nmap-full)
    echo "----------------------------------------------"
    echo "nmap full scan results - $subnet/24"
    echo "----------------------------------------------"
    sudo nmap $subnet/24
    ;;
  *)
    echo "Invalid scan type: $scan_type" >&2
    exit 1
    ;;
esac