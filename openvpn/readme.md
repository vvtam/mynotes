#openvpn install#

##版本信息##

os:centos 7

openvpn:openvpn-2.3.11.tar.gz    
```
https://openvpn.net/index.php/download/community-downloads.html
https://github.com/OpenVPN/openvpn
https://swupdate.openvpn.org/community/releases/openvpn-2.3.11.tar.gz
```

easy-rsa:v3.0.1

https://github.com/OpenVPN/easy-rsa

##安装##

```
yum -y install net-tools lzo-devel pam-devle #安装依赖，如果编译安装报错，请根据报错信息解决
./configure --prefix=/usr/local/openvpn
make
make install

#cp openvpn配置文件
mkdir -p /usr/local/openvpn/ect
cp -r /openvpn/src/dir/sample/sample-config-files/* /usr/local/openvpn/etc

#生成密钥和证书,运行 ./easyrsa 获取帮助信息
cp -r /easyrsa/src/dir/easyrsa3/* /usr/local/openvpn/easyrsa3/
cd /usr/loacl/openvpn/esayrsa3
./easyrsa init-pki
./easyrsa build-ca
./easyrsa gen-dh
./easyrsa build-server-full
./easyrsa build-client-full

#修改openvpn server配置文件
vim /usr/local/openvpn/etc/server.conf 

ca 
cert 
key 
dh
push "redirect-gateway def1 bypass-dhcp"
push "dhcp-option DNS 114.114.114.114"
push "dhcp-option DNS 223.5.5.5"
client-to-client
comp-lzo
user nobody
group nobody 
```

##客户端##
OS X https://tunnelblick.net/

##firewalld配置##

```
firewall-cmd --permanent --add-service openvpn
firewall-cmd --permanent --zone=trusted --add-interface=tun0
firewall-cmd --permanent --zone=trusted --add-masquerade
DEV=$(ip route get 8.8.8.8 | awk 'NR==1 {print $(NF-2)}')
firewall-cmd --permanent --direct --passthrough ipv4 -t nat -A POSTROUTING -s  10.8.0.0/24 -o $DEV -j MASQUERADE
firewall-cmd --reload
```
```
iptables 替换成自己的端口
iptables -A INPUT -i eth1 -m state --state NEW -p udp --dport 1194 -j ACCEPT
iptables -A INPUT -i tun0 -j ACCEPT
iptables -A FORWARD -i tun0 -j ACCEPT
iptables -A FORWARD -i tun0 -o eth1 -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -A FORWARD -i eth1 -o tun0 -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -t nat -A POSTROUTING -s 10.8.0.0/24 -o eth1 -j MASQUERADE
iptables -A OUTPUT -o tun0 -j ACCEPT
```
