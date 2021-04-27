dropbear 服务端启动的时候只创建了rsa，dss key  
在客户端链接的时候 -v 看到下面报错

```
expecting SSH2_MSG_KEX_ECDH_REPLY
Connection closed by 1.x.x.x port xxx
```
于是在服务端添加ecdsa，ed255519 key，重启dropbear  
问题解决
