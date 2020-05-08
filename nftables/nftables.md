# nftables

原文地址

## [transition-to-nftables](https://opensourceforu.com/2019/10/transition-to-nftables/)

nftables

## 地址族

ip

ipv6

inet(ip and ipv6)

arp

bridge

netdev

## 表-链-规则

table

​	chain

​		rules

​			fileter

​			NAT

​			route

input

output

forward

pre-routing

post-routing

## nft

终端中要加入’\‘转义，在脚本中不用加

```nftables
清空规则，新建filter表，新建input 链，默认drop
nft flush ruleset
nft list ruleset
nft add table inet filter
nft add chain inet filter input { type filter hook input priority 0 \; counter \; policy drop \; }
```

```
input 添加lo，eth0 相关规则
nft add rule inet filter input iifname lo accept
nft add rule inet filter input iifname eth0 ct state new, established, related accept
```

```
drop tcp flags
nft add rule inet filter input iifname enpXsY tcp flags \& \(syn\|fin\) == \(syn\|fin\) drop 
nft add rule inet filter input iifname enpXsY tcp flags \& \(syn\|rst\) == \(syn\|rst\) drop 
nft add rule inet filter input iifname enpXsY tcp flags \& \(fin\|rst\) == \(fin\|rst\) drop 
nft add rule inet filter input iifname enpXsY tcp flags \& \(ack\|fin\) == fin drop 
nft add rule inet filter input iifname enpXsY tcp flags \& \(ack\|psh\) == psh drop 
nft add rule inet filter input iifname enpXsY tcp flags \& \(ack\|urg\) == urg drop
```

```
drop icmp
nft add rule inet filter input iifname enpXsY icmp type { echo-reply, destination-unreachable, time-exceeded } limit rate 1/second accept
nft add rule inet filter input iifname enpXsY ip protocol icmp drop
```

```
添加日志
nft add rule inet filter input iifname enpXsY ct state invalid log flags all level info prefix \”Invalid-Input: \”
nft add rule inet filter input iifname enpXsY ct state invalid drop
```

```
forward and output
nft add chain inet filter forward { type filter hook forward priority 0 \; counter \; policy drop \; }
nft add rule inet filter forward ct state established, related accept
nft add rule inet filter forward ct state invalid drop
nft add chain inet filter output { type filter hook output priority 0 \; counter \; policy drop \; }
nft add rule inet filter output oifname enpXsY tcp dport { 80, 443 } ct state established accept
nft add rule inet filter output oifname enpXsY icmp type { echo-request, destination-unreachable, time-exceeded } limit rate 1/second accept 
nft add rule inet filter output oifname enpXsY ip protocol icmp drop
nft add rule inet filter output oifname enpXsY ct state invalid log flags all level info prefix \”Invalid-Output: \”
nft add rule inet filter output oifname enpXsY ct state invalid drop
```

```
logging in rsyslog
go to /etc/rsyslog.d and create a file called nftables.conf
:msg,regex,”Invalid-Input: “ -/var/log/nftables/Input.log
:msg,regex,”Invalid-Output: “ -/var/log/nftables/Output.log
& stop
```

```
/etc/logrotate.d called nftables
/var/log/nftables/* { rotate 5 daily maxsize 50M missingok notifempty delaycompress compress postrotate invoke-rc.d rsyslog rotate > /dev/null endscript }
```



