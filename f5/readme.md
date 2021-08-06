## 配置

tmsh 进入配置

查看用户

list auth user

创建用户

create auth user yourname partition-access add { all-partitions { role admin} } description xxxxyyy password 'yourpassword' shell bash

修改 ltm 接口允许的源IP

modify ltm virtual vs_proxy_9090 source x.x.x.x/y
