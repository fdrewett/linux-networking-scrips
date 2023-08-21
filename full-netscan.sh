#!/bin/bash

# Function to check if a command exists
command_exists() {
  if command -v "$1" &>/dev/null; then
    echo "Found: $1"
  else
    echo "Error: $1 is not installed." >&2
    exit 1
  fi
}

echo "OS Detected: $(uname)"

# Check for required commands
command_exists arp-scan
command_exists nmap

OS=$(uname)

# Function to retrieve IP and subnet for macOS
get_mac_ip() {
  ip_address=$(route -n get default | grep interface | awk '{print $2}' | xargs -I {} ifconfig {} | grep "inet " | awk '{print $2}')
  stripped_last_octet=$(echo $ip_address | cut -d"." -f1-3)
  echo "$stripped_last_octet.0/24"
}

# Function to retrieve IP and subnet for Linux
get_linux_ip() {
  ip_address=$(ip route get 1 | awk '{print $NF;exit}')
  stripped_last_octet=$(echo $ip_address | cut -d"." -f1-3)
  echo "$stripped_last_octet.0/24"
}

# Determine OS and get IP/subnet accordingly
if [ "$OS" = "Darwin" ]; then
  subnet=$(get_mac_ip)
elif [ "$OS" = "Linux" ]; then
  subnet=$(get_linux_ip)
else
  echo "Unsupported OS"
  exit 1
fi

# arp-scan
echo "----------------------------------------------"
echo "arp scan results - $subnet"
echo "----------------------------------------------"
sudo arp-scan $subnet

# nmap quick scan
echo "----------------------------------------------"
echo "nmap quick scan results - $subnet"
echo "----------------------------------------------"
sudo nmap -sn $subnet

# nmap full scan
echo "----------------------------------------------"
echo "nmap full scan results - $subnet"
echo "----------------------------------------------"
sudo nmap $subnet
