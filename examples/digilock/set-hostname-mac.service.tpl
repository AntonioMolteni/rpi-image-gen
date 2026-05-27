[Unit]
Description=Set hostname from MAC address
DefaultDependencies=no
Before=network-pre.target

[Service]
Type=oneshot
ExecStart=/bin/sh -c 'IF=${IFACE}; MAC=$(cat /sys/class/net/$IFACE/address); SFX=$(echo $MAC | awk -F: '{print toupper($(NF-1)$(NF))}'); HN="${BASE}-${SFX}"; hostnamectl set-hostname $HN; echo $HN > /etc/hostname; sed -i "/127.0.1.1/c\127.0.1.1\t$HN" /etc/hosts || true'

[Install]
WantedBy=network-pre.target
