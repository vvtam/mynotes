# rsync

## 常用选项

-n 测试，不实际运行

-v --verbose

-a --archive 存档模式 相当于 -rlptgoD

-H 保留硬链接

-A 保留ACL

-X 保留SELinux上下文

rsync -av __Webroot/__ --exclude=htdocs/asset --exclude=htdocs/epg NewWebroot  源目录加上斜杠，同步目录内容，不会在目标目录中新建子目录

rsync -av **Webroot** --exclude=htdocs/asset --exclude=htdocs/epg NewWebroot 源目录没有尾随斜杠，会在目标目录中新建子目录

##  rsync ssh

```shell
rsync -avlR --exclude-from=rsync_cig_exclude.list -e ssh cig root@test151:/data/wwwroot/
rsync -avlR --exclude-from=rsync_cig_exclude.list -e 'ssh -p 43211' cig root@test151:/data/wwwroot/
rsync -avlR --exclude 'rsync_cig_exclude.list' -e 'ssh -p 43211' cig root@test151:/data/wwwroot/
```

排除文件列表用相对路径，比如下面脚本  
```
#!/bin/bash

cd /data/wwwroot/
rsync -avlR --exclude-from=rsync_cig_exclude.list -e ssh cig root@test151:/data/wwwroot/

ssh root@test151 "rm -rf /data/cache.php"
```

rsync_cig_exclude.list  **0**
相对于上面脚本来说的相对目录，比如一个完整的目录是  
/data/wwwroot/cig/app/config/*

```
app/config/*
.git*
```
## rsync daemon
rsync -avz --progress --delete --bwlimit=500 --password-file=/usr/local/rsyncd.secrets /host/web vhost@hostname  

/host/web 这种格式会在122_163指定的路径下创建web目录  
/host/web/  这样就会在模板指定的路径下创建web下包含的目录和文件，而不会创建web目录  
Windows下面格式

rsync -avz --progress --delete --bwlimit=500 /cygdrive/d/web vhost@host < c:\rsyncd.secrets > c:\rsync.log

路径有空格的时候  

rsync -avz --progress --delete --bwlimit=500 /cygdrive/d/"Program Files"/"Microsoft SQL Server"/MSSQL.1/MSSQL/Data vhost@host::218_172 < c:\rsyncd.secrets  ## Windows下密钥文件 c:\rsyncd.secrets log日志文件c:\rsync.log dos窗口不输出 ，linux下  /usr/local/rsyncd.secrets 读取权限指定600。  183 rsync 配置文件 /etc/rsyncd.conf  密钥文件 /etc/rsyncd.secrets 欢迎信息 /etc/rsyncd.motd  ，启动方式 rsync --daemon --config=/etc/rsyncd.conf  加入到了/etc/rc.local   rsync服务器端的UID GID都设置的root ，设置成nobody 会报错，没有权限操作目录

