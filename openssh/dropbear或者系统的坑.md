dropbear 服务端启动的时候只创建了rsa，dss key  
在客户端链接的时候 -v 看到下面报错

```
expecting SSH2_MSG_KEX_ECDH_REPLY
Connection closed by 1.x.x.x port xxx
```

于是在服务端添加ecdsa，ed255519 key，重启dropbear  
问题解决



升级openssh到9.0后，连接其它安装dropbear的机器报错`Unable to negotiate with 192.168.166.72 port 12322: no matching host key type found. Their offer: ssh-rsa,ssh-dss`

高版本openssh默认不支持 rsa，dss，ssh 添加选项连接

`ssh -oHostKeyAlgorithms=+ssh-rsa -p12322 192.168.166.72`
