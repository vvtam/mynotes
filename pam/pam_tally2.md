## pam_tally2

pam_tally2.so deny=5 onerr=fail unlock_time=300 # 密码错误5次锁定300秒

```
[-u username] [--user username]
   [-r] [--reset[=n]] [--quiet]
```

```
pam_tally2 -u user # 查看
pam_tally2 -u user --reset #重置，解锁
```

