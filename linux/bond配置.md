#bond配置
##bond模式
0，1，2，3，4，5，6共七种模式  
常用的模式：  
mode=0：平衡负载模式，有自动备援，但需要_Switch_支援及设定。  
mode=1：自动备援模式，其中一条线若断线，其他线路将会自动备援。  
mode=6：平衡负载模式，有自动备援，不必”Switch”支援及设定。
##网卡配置
比如2块（p4p1，p4p2）做成一个bond0  
bond0：  
```
DEVICE=bond0
TYPE=Ethernet
IPADDR=192.168.91.89
PREFIX=25
DEFROUTE=yes
IPV4_FAILURE_FATAL=yes
IPV6INIT=no
ONBOOT=yes
BOOTPROTO=static

```
p4p1：  
```
DEVICE=p4p1
TYPE=Ethernet
ONBOOT=yes
NM_CONTROLLED=yes
BOOTPROTO=none
DEFROUTE=yes
IPV4_FAILURE_FATAL=yes
IPV6INIT=no
MASTER=bond0
SLAVE=yes

```
p4p2：  
```
DEVICE=p4p2
TYPE=Ethernet
ONBOOT=yes
NM_CONTROLLED=yes
BOOTPROTO=none
DEFROUTE=yes
IPV4_FAILURE_FATAL=yes
IPV6INIT=no
MASTER=bond0
SLAVE=yes
```
配置/etc/modprobe.d/dist.conf添加：  
```
alias bond0 bonding
options bonding mode=0 miimon=200
```
载入bonding配置  
`modprobe bongding`

*其它配置类似*