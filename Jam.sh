# Kontrola či je skript spustený so sudo
if [ "$EUID" -ne 0 ]; then
  echo "Cant start.\nPlease start it with sudo ./Jam.sh"
  exit 1
fi

