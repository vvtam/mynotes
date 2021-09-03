## 配置

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
modify ltm pool mypool { members add { 14.18.65.15:https { address 14.18.65.15 } 14.18.65.14:https { address 14.18.65.14 } 14.18.65.103:https { address 14.18.65.103 } 14.24.239.233:https { address 24.24.239.233 } 12.24.239.232:https { address 12.24.239.232 } 12.23.239.231:https { address 12.23.239.231 } } }
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

