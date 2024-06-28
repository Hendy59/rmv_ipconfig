#!/bin/bash

# Funktion zur Ermittlung der MAC-Adresse
get_mac_address() {
    local interface="eth0"
    local mac=$(ip link show $interface | awk '/ether/ {print $2}')
    echo $mac
}

# Eingabeaufforderung für die IP-Adresse
read -p "Bitte geben Sie die gewünschte IP-Adresse ein: " ip_address

# Überprüfen, ob eine IP-Adresse eingegeben wurde
if [ -z "$ip_address" ]; then
    echo "Keine IP-Adresse eingegeben. Das Skript wird beendet."
    exit 1
fi

# MAC-Adresse ermitteln
mac_address=$(get_mac_address)

# Konfiguration in die Datei schreiben
sudo tee /etc/network/interfaces << EOF
auto eth0
iface eth0 inet static
  address $ip_address
  netmask 255.255.255.0
  gateway 172.20.23.1
  dns-nameservers 172.16.5.112 172.16.5.113
EOF

# Netzwerkdienst neu starten
sudo systemctl restart networking.service

echo "Netzwerkkonfiguration abgeschlossen."
echo "Neue IP-Adresse: $ip_address"
echo "MAC-Adresse von eth0: $mac_address"