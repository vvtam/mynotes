## 配置

### 备份，恢复

```
tmsh save sys ucs $(echo $HOSTNAME | cut -d'.' -f1)-$(date +%H%M-%m%d%y)

tmsh load /sys ucs /var/tmp/MyUCS.ucs
```

### 查看用户

 `# list auth user`

### ltm 接口

`modify ltm virtual vs_proxy_9090 source x.x.x.x/y`

```
# list ltm pool Pool_xxx 
ltm pool Pool_xxx {
    members {
        ip1:https {
            address ip1
        }
        ip2:https {
            address ip2
        }
    }
}
```

`create ltm node xxx`

```
modify ltm pool mypool members add { 14.18.65.15:https 14.18.65.14:https 14.18.65.103:https 14.24.239.233:https 12.24.239.232:https 12.23.239.231:https }
```

`modify ltm pool mypoolmembers delete { 42.62.16.26:https 42.62.16.27:https }`

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

