#!/bin/bash

# Check if the script is run with sudo
if [ "$(id -u)" -ne 0 ]; then
  echo "------------------------------------------------------------" | lolcat
  echo "[+] \e[31mCANT START WITHOUT SUDO PERMISSION\e[0m [+]" | lolcat
  echo "[+] Please start this script with                       [+]" | lolcat
  echo "[+]         --> \e[31msudo ./Jam.sh\e[0m                           [+]" | lolcat
  echo "------------------------------------------------------------" | lolcat
  exit 1
fi

# Your existing script logic goes here for the part that follows when executed with sudo

echo "Script is running with sudo permission." | lolcat
# Continue your script execution here
