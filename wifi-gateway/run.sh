#!/usr/bin/env bashio

echo "Starting Wi-Fi to Ethernet Gateway (NAT)..."

ETH_IF="end0"
if ! ip link show $ETH_IF > /dev/null 2>&1; then
    ETH_IF="eth0"
fi

echo "Using Ethernet interface: $ETH_IF"

ip addr add 10.42.0.1/24 dev $ETH_IF || true
ip link set $ETH_IF up

iptables -t nat -A POSTROUTING -o wlan0 -j MASQUERADE
iptables -A FORWARD -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
iptables -A FORWARD -i $ETH_IF -o wlan0 -j ACCEPT

cat << EOF_DNSMASQ > /etc/dnsmasq.conf
interface=$ETH_IF
bind-interfaces
dhcp-range=10.42.0.10,10.42.0.100,12h
dhcp-option=3,10.42.0.1
dhcp-option=6,8.8.8.8,1.1.1.1
EOF_DNSMASQ

echo "Starting dnsmasq..."
dnsmasq -k
