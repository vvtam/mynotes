#!/bin/bash

IP0=1.2.3.4
IP1=192.168.1.4
GATE=1.2.3.1
PRE0=26
PRE1=24
ETH1=em1
ETH2=em3
nmcli con add type team con-name team0 ifname team0 config '{"runner": {"name":"activebackup"}}'
cat <<EOF> /etc/sysconfig/network-scripts/ifcfg-$ETH1
TYPE=Ethernet
BOOTPROTO=dhcp
DEFROUTE=yes
IPV4_FAILURE_FATAL=yes
IPV6INIT=no
IPV6_AUTOCONF=yes
IPV6_DEFROUTE=yes
IPV6_FAILURE_FATAL=no
NAME=$ETH1
DEVICE=$ETH1
ONBOOT=yes
IPV6_PEERDNS=yes
IPV6_PEERROUTES=yes
PEERDNS=yes
PEERROUTES=yes
EOF
cat <<EOF> /etc/sysconfig/network-scripts/ifcfg-$ETH2
TYPE=Ethernet
BOOTPROTO=dhcp
DEFROUTE=yes
IPV4_FAILURE_FATAL=yes
IPV6INIT=no
IPV6_AUTOCONF=yes
IPV6_DEFROUTE=yes
IPV6_FAILURE_FATAL=no
NAME=$ETH2
DEVICE=$ETH2
ONBOOT=yes
IPV6_PEERDNS=yes
IPV6_PEERROUTES=yes
PEERDNS=yes
PEERROUTES=yes
EOF
cat <<EOF> /etc/sysconfig/network-scripts/ifcfg-team0
DEVICE=team0
TEAM_CONFIG="{\"runner\": {\"name\":\"activebackup\"}}"
DEVICETYPE=Team
BOOTPROTO=static
DEFROUTE=yes
IPV4_FAILURE_FATAL=yes
IPV6INIT=no
IPV6_AUTOCONF=yes
IPV6_DEFROUTE=yes
IPV6_FAILURE_FATAL=no
NAME=team0
ONBOOT=yes
IPV6_PEERDNS=yes
IPV6_PEERROUTES=yes
IPADDR0=$IP0
PREFIX0=$PRE0
GATEWAY0=$GATE
IPADDR1=$IP1
PREFIX1=$PRE1
DNS1=1.2.3.4
DNS2=3.4.5.6
EOF
nmcli connection add type team-slave con-name team0-port1 ifname $ETH1 master team0
nmcli connection add type team-slave con-name team0-port2 ifname $ETH2 master team0
nmcli connection up team0-port2
nmcli connection up team0-port1
reboot
