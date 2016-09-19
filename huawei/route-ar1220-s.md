#AR1220-S#
```
这个要重新配置下。下面的配置你可以参考下。
Q：内网服务器的访问方式及各自的配置方法
A：内网服务器的访问方式有以下五种
内网服务器有域名，DNS服务器在公网侧，内网用户通过域名访问
内网服务器有域名，DNS服务器在内网侧，内网用户通过域名访问
内网服务器没有域名，内网用户通过内网IP地址访问
内网服务器没有域名，外网用户通过外网IP地址访问
内网服务器没有域名，内网用户通过外网IP地址访问
其中：
内网服务器有域名，DNS服务器在内网侧，内网用户通过域名访问；
内网服务器没有域名，内网用户通过内网IP地址访问；
——这两种访问方式，AR上无需特殊配置
内网服务器没有域名，外网用户通过外网IP地址访问
——这种方式AR上需完成 Nat server 配置即可。
1、内网服务器有域名，DNS服务器在公网侧，内网用户通过域名访问
————方法：Nat mapping + DNS ALG
配置Nat Server完成后需增加： nat alg dns enable
nat dns-map abcdef.com(域名） 11.49.118.242（内网服务器的外网ip) 80 tcp
2、内网服务器没有域名，内网用户通过外网IP地址访问
————方法：通过流策略重定向下一跳
配置举例：#
acl number 3000 
rule 5 permit ip source 192.168.0.0 0.0.0.255 destination （外网ip）11.11.11.11 0 
#
traffic classifier redirect operator or
if-match acl 3000
#
traffic behavior redirect
redirect ip-nexthop 11.11.11.1-----------必须指定IP地址（外网ip 11.11.11.11的网关）
#
traffic policy redirect
classifier redirect behavior redirect
#
interface Ethernet0/0/0
traffic-policy redirect inbound------------绑定在内网物理口的Inbound方向
```
