#!/bin/bash
# -------------------------------------------------------------------------- #
# Author     : Fattcat
# YT Channel : https://www.youtube.com/channel/UCKfToKJFq-uvI8svPX0WzYQ
# -------------------------------------------------------------------------- #

#!/bin/bash

# Function to display the menu
show_menu() {
  echo "------------------------------------------------------------" | lolcat
  echo "[+] \e[32mJAMMING SCRIPT MENU\e[0m [+]" | lolcat
  echo "------------------------------------------------------------" | lolcat
  echo "[1] List connected WiFi adapters" | lolcat
  echo "[2] Jam WiFi networks" | lolcat
  echo "[3] Map connected devices" | lolcat
  echo "[4] Exit" | lolcat
  echo "------------------------------------------------------------" | lolcat
}

# Function to list connected WiFi adapters
list_adapters() {
  echo "List of connected WiFi Adapters :" | lolcat
  index=1
  for adapter in $(iwconfig 2>/dev/null | grep 'IEEE\|ESSID' | cut -d ' ' -f 1); do
    echo "[+] $index. $adapter --> ($(iwconfig $adapter | grep ESSID | cut -d ':' -f 2 | tr -d '"'))" | lolcat
    ((index++))
  done
}

# Function to jam WiFi networks
jam_networks() {
  # Add your jamming logic here
  echo "Jamming WiFi networks..."
}

# Function to map connected devices
map_devices() {
  echo "Connected devices:" | lolcat
  echo "----------------------------------------------------------" | lolcat
  connected_devices=$(sudo arp-scan --interface=wlan0 --localnet | grep -v "$(ip -4 addr show wlan0 | grep -oP '(?<=inet\s)\d+(\.\d+){3}')")
  sorted_devices=$(echo "$connected_devices" | sort -n -t . -k 1,1 -k 2,2 -k 3,3 -k 4,4)
  while IFS=$'\t' read -r ip mac name brand other_info; do
    echo -e "$ip\t$mac\t$name\t$brand\t$other_info" | lolcat
  done <<< "$sorted_devices"
}

# Main script
while true; do
  show_menu
  read -p "Select an option (1-4): " choice

  case $choice in
    1)
      list_adapters
      ;;
    2)
      jam_networks
      ;;
    3)
      map_devices
      ;;
    4)
      echo "Exiting..." | lolcat
      exit 0
      ;;
    *)
      echo "Invalid choice. Please enter a number between 1 and 4." | lolcat
      ;;
  esac
done
