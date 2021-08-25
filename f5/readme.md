## 配置

### 查看用户

`list auth user`

### 修改 ltm 接口允许的源IP

`modify ltm virtual vs_proxy_9090 source x.x.x.x/y`

### 新建用户

```
tmsh
create auth user yourname
modify auth user yourname password 7DMMHajq@!#
modify auth user yourname partition-access modify { all-partitions { role admin } }
modify auth user yourname partition-access modify { all-partitions { role admin } } shell bash
save sys config current-partition base
```

### 修改用户

```
tmsh
modify auth password root
save sys config
quit
```

