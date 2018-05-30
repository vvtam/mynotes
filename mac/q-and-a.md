```
问题描述：原为管理员帐户，修改了account name和Full name后，不但没修改成功，
而且管理员账号变成了普通的账号

解决：
1 按住command+s 再开机，登录到shell
2 /sbin/mount -uaw
  rm var/db/.AppleSetupDone
  reboot
3 重启后登录的时候创建新的管理员账号，然后修改之前的用户为管理员账户

4 重新登录之前的账号，删除新建的账号
```
