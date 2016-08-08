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

##启动##
```
pppoe-server -I eno1 -L 10.10.10.1 -R 10.10.10.100-200
```
