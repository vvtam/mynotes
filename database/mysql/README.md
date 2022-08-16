## MySQL集群重启

slave停机

```
slave stop

mysqladmin shutdown -uxx -pxx
```

master 停机

`mysqladmin shutdown -uxx -pxx`



查看插件目录

```
show variables like '%plugin_dir%';
+---------------+--------------------------------------------+
| Variable_name | Value                                      |
+---------------+--------------------------------------------+
| plugin_dir    | /home/data/thirdAssembly/mysql/lib/plugin/ |
+---------------+--------------------------------------------+
```



5.7安装密码插件

`INSTALL PLUGIN validate_password SONAME 'validate_password.so';`


