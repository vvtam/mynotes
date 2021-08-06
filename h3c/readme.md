show ip routing-table

show ip routing-table destination_ip

system-view

ip route-static ip  mask next



### 开启ssh

```
# 生成RSA密钥对。

<Device> system-view
[Device] public-key local create rsa
The range of public key modulus is (512 ~ 2048).
If the key modulus is greater than 512, it will take a few minutes.
Press CTRL+C to abort.
Input the modulus length [default = 1024]:
Generating Keys...
..
Create the key pair successfully.
# 生成DSA密钥对。
[Device] public-key local create dsa
The range of public key modulus is (512 ~ 2048).
If the key modulus is greater than 512, it will take a few minutes.
Press CTRL+C to abort.
Input the modulus length [default = 1024]:
Generating Keys...
......
Create the key pair successfully.
# 生成ECDSA密钥对。
[Device] public-key local create ecdsa secp256r1
Generating Keys...
.
Create the key pair successfully.
# 使能SSH服务器功能。
[Device] ssh server enable
# 创建VLAN 2，并将Ten-GigabitEthernet1/0/2加入VLAN 2。
[Device] vlan 2
[Device-vlan2] port ten-gigabitethernet 1/0/2
[Device-vlan2] quit
# 配置VLAN接口2的IP地址，客户端将通过该地址连接Stelnet服务器。
[Device] interface vlan-interface 2
[Device-Vlan-interface2] ip address 192.168.1.40 255.255.255.0
[Device-Vlan-interface2] quit
# 设置Stelnet客户端登录用户界面的认证方式为scheme。
[Device] line vty 0 63
[Device-line-vty0-63] authentication-mode scheme
[Device-line-vty0-63] quit
# 创建本地用户client001，并设置用户密码、服务类型和用户角色。
[Device] local-user client001 class manage
New local user added.
[Device-luser-manage-client001] password simple aabbcc
[Device-luser-manage-client001] service-type ssh
[Device-luser-manage-client001] authorization-attribute user-role network-admin
[Device-luser-manage-client001] quit

```

### 高级acl配置，并且应用到端口

```
<H3C> system-view
[H3c] acl number 3100
[H3C-acl-adv-3100] rule deny icmp xxx
[H3C-acl-adv-3100] quit

[H3C] interface xxx
[H3C-XXX] packet-filter 3100 inbound
[H3C-xxx] quit
```



系统预定义的用户角色名和对应的权限

| 用户角色名              |                             权限                             |
| ----------------------- | :----------------------------------------------------------: |
| network-admin           | 可操作系统所有功能和资源（除安全日志文件管理相关命令display security-logfile summary、info-center security-logfile directory、security-logfile save之外） |
| network-operator        | ·   可执行系统所有功能和资源的相关display命令（除display history-command all、display security-logfile summary等命令，具体请通过display role命令查看）·   如果用户采用本地认证方式登录系统并被授予该角色，则可以修改自己的密码·   可执行进入XML视图的命令·   可允许用户操作所有读类型的XML元素·   可允许用户操作所有读类型的OID |
| level-*n* (*n* = 0～15) | ·   level-0：可执行命令ping、quit、ssh2、super、system-view、telnet和tracert，且管理员可以为其配置权限·   level-1：具有level-0用户角色的权限，并且可执行系统所有功能和资源的相关display命令（除display history-command all之外），以及管理员可以为其配置权限·   level-2～level-8和level-10～level-14：无缺省权限，需要管理员为其配置权限·   level-9：可操作系统中绝大多数的功能和所有的资源，且管理员可以为其配置权限，但不能操作display history-command all命令、RBAC的命令（Debug命令除外）、文件管理、设备管理以及本地用户特性。对于本地用户，若用户登录系统并被授予该角色，可以修改自己的密码。·   level-15：具有与network-admin角色相同的权限。·   l |
| security-audit          | 安全日志管理员，仅具有安全日志文件的读、写、执行权限，具体如下：·   可执行安全日志文件管理相关的命令（display security-logfile summary、info-center security-logfile directory、security-logfile save）。安全日志文件管理相关命令的介绍，请参见“网络管理与监控”中的“信息中心”·   可执行安全日志文件操作相关的命令，例如more显示安全日志文件内容；dir、mkdir操作安全日志文件目录等，具体命令的介绍请参见“基础配置命令参考”中的“文件系统管理”·   以上权限，仅安全日志管理员角色独有，其它任何角色均不具备，且即使在其它用户角色中配置了以上权限，也不生效 |
