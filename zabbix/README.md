## 添加web监控

- zabbix web监控的url地址要编码-有中文的时候

- 可以 302 跳转

- 可以post

## 问题

- zabbix执行bash脚本的时候，脚本里面判断文件或者路径等情况，zabbix用户没用权限，脚本失败

- 本机执行zabbix_get报错

  `zabbix_get [5309]: Check access restrictions in Zabbix agent configuration`
添加 127.0.0.1 到agent配置的server

