## 添加web监控

- zabbix web监控的url地址要编码-有中文的时候

- 可以 302 跳转

- 可以post

## 问题

- zabbix执行bash脚本的时候，脚本里面判断文件或者路径等情况，zabbix用户没用权限，脚本失败
- zabbix配置文件里面调用命令写绝对路径，否者可能失败
- mysql目录权限不对，导致zabbix_get 获取不到正确的值

- 本机执行zabbix_get报错

  `zabbix_get [5309]: Check access restrictions in Zabbix agent configuration`
添加 127.0.0.1 到agent配置的server

- zabbix get We trust you have received the usual lecture from the local System Administrator. It usually boils down to these three things； zabbix_get得到的值，需要检查sudo 权限
sudoers文件添加相应权限

      `zabbix  ALL=(ALL)       NOPASSWD:/usr/local/sbin,/usr/local/bin,/usr/sbin,/usr/bin,/usr/bin/systemctl,/bin/chmod,/usr/bin/chage,/bin/mkdir,/bin/echo,/bin/sed,/bin/cat,/bin/ls,/bin/grep,/bin/egrep,/bin/awk,/usr/bin/crontab,/bin/netstat,/sbin/ss,/usr/sbin/lsof,/usr/sbin/iftop,/usr/bin/python,/bin/readlink,/usr/bin/echo,/usr/sbin/fping,/usr/sbin/fpin6`

- [main] Error saving history file: FileOpenFailed: Unable to open() file /root/.dbshell
  监控mongodb报错，需要sudo 执行，然后sudoers里面需要加上/bin/sh,/bin/bash

  推荐方法，zabbix执行脚本是用zabbix权限执行，但是$HOME环境变量还是/root/，只需要在命令前添加export HOME='/home/zabbix'，即可解决问题


- fping icmp 报错
  
  `chmod u+s /usr/local/sbin/fping`

- zabbix get 报错 sudo: sorry, you must have a tty to run sudo    
    zabbix 监控脚本使用了sudo，报错，需要配置sudoers文件
  ```
  Defaults requiretty修改为 #Defaults requiretty
  或者 Defaults:zabbix !requiretty
  增加行 Defaults visiblepw 
  否则会出现 sudo: no tty present and no askpass program specified