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

