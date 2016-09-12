#pppoe server#

yum install rp-pppoe

##配置服务端##
```
vim /etc/ppp/pppoe-server-options
# PPP options for the PPPoE server
# LIC: GPL
require-pap
require-chap
login
lcp-echo-interval 10
lcp-echo-failure 2
logfile /var/log/pppoe.log

ms-dns 223.5.5.5
ms-dns 114.114.114.114

defaultroute
```
##配置用户##
```
vim /etc/ppp/chap-secrets
# Secrets for authentication using CHAP
# client	server	secret			IP addresses
pppoe           *      "123456"                 *
```
##防火墙配置##
```
iptables -A POSTROUTING -t nat -s 10.10.10.0/24 -j MASQUERADE
iptables -A FORWARD -p tcp --syn -s 10.10.10.0/24 -j TCPMSS --set-mss 1499

firewall-cmd --direct --add-rule ipv4 nat POSTROUTING 0 -o eno1 -j MASQUERADE
firewall-cmd --direct --add-rule ipv4 filter FORWARD 0 -i ppp0 -o eno1 -j ACCEPT
firewall-cmd --direct --add-rule ipv4 filter FORWARD 0 -i eno1 -o ppp0 -m state --state RELATED,ESTABLISHED -j ACCEPT

net.ipv4.ip_forward=1
```

##启动##
```
pppoe-server -I eno1 -L 10.10.10.1 -R 10.10.10.100-200
```
