## 添加web监控

- zabbix web监控的url地址要编码-有中文的时候

- 可以 302 跳转

- 可以post

## 问题

- zabbix执行bash脚本的时候，脚本里面判断文件或者路径等情况，zabbix用户没用权限，脚本失败
- zabbix配置文件里面调用命令写绝对路径，否者可能失败

- 本机执行zabbix_get报错

  `zabbix_get [5309]: Check access restrictions in Zabbix agent configuration`
添加 127.0.0.1 到agent配置的server

- zabbix get We trust you have received the usual lecture from the local System Administrator. It usually boils down to these three things； zabbix_get得到的值，需要检查sudo 权限
sudoers文件添加相应权限

      `zabbix  ALL=(ALL)       NOPASSWD:/usr/local/sbin,/usr/local/bin,/usr/sbin,/usr/bin,/usr/bin/systemctl,/bin/chmod,/usr/bin/chage,/bin/mkdir,/bin/echo,/bin/sed,/bin/cat,/bin/ls,/bin/grep,/bin/egrep,/bin/awk,/usr/bin/crontab,/bin/netstat,/sbin/ss,/usr/sbin/lsof,/usr/sbin/iftop,/usr/bin/python,/bin/readlink,/usr/bin/echo,/usr/sbin/fping,/usr/sbin/fpin6`