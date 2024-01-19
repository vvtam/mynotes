nmcli con add con-name bond0 ifname bond0 type bond mode active-backup
sleep 2
nmcli con add con-name bond0-port1 ifname eno1 type bond-slave master bond0
sleep 2
nmcli con add con-name bond0-port2 ifname eno2 type bond-slave master bond0
sleep 3
nmcli con mod bond0 ipv4.address 192.168.20.2/24 ipv4.gateway 192.168.20.1 ipv4.method manual ipv6.method disabled
sleep 3
nmcli con mod bond0 connection.autoconnect yes
sleep 2
nmcli con up bond0