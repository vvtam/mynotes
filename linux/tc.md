```
tc qdisc add dev em1 root handle 1: htb
tc class add dev em1 parent 1:1 classid 1:1 htb rate 3Mbit ceil 10Mbit
tc filter add dev em1 parent 1: prio 1 protocol ip u32 match ip protocol 4 0xff match ip dport 30001 0xffff classid 1:10
tc filter add dev em1 protocol ip parent 1: prio 1 u32 match ip dport 30001 0xffff flowid 1:10


tc qdisc del dev em1 root 2>/dev/null
tc qdisc add dev em1 root handle 1: htb default 1
tc class add dev em1 parent 1: classid 1:1 htb rate 1000Mbit
tc class add dev em1 parent 1:1 classid 1:10 htb rate 10Mbit ceil 10Mbit
tc qdisc add dev em1 parent 1:10 handle 10 sfq perturb 10

tc filter add dev em1 parent 1:1 protocol ip u32 match ip sport 30001 0xffff flowid 1:10

tc filter add dev em1 parent 1:1 protocol ip prio 1 handle 10 fw classid  1:10
iptables -A PREROUTING -t mangle -i em1 -d 10.1.10.59/24 -j MARK --set-mark 1
```

```
tc qdisc del dev em1 root 2>/dev/null
tc qdisc add dev em1 root handle 1: htb default 1  #default 12 assigned to class 1:12
tc class add dev em1 parent 1: classid 1:1 htb rate 1000Mbit ceil 1000Mbit 
tc class add dev em1 parent 1:1 classid 1:10 htb rate 2Mbit ceil 10Mbit
tc filter add dev em1 protocol ip parent 1:1 prio 1 u32 match ip dport 30001 0xffff flowid 1:10
tc filter add dev eth0 protocol ip parent 1:0 prio 1 u32 match ip src 1.2.3.4 flowid 1:11

tc -s -d class show dev em1
```

```
tc qdisc add dev em1 root handle 1: cbq avpkt 1000 bandwidth 1000Mbit
tc class add dev em1 parent 1: classid 1:1 cbq rate 10Mbit allot 1500 bounded
tc class add dev em1 parent 1: classid 1:2 cbq rate 50Mbit allot 1500 bounded
tc filter add dev em1 parent 1: protocol ip u32 match ip protocol 6 0xff match ip dport 30001 0xffff flowid 1:1
```

