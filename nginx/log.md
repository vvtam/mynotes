## 使用access_log支持变量来分割日志
来源 https://jingsam.github.io

```
if ($time_iso8601 ~ "^(\d{4})-(\d{2})-(\d{2})") {
  set $year $1;
  set $month $2;
  set $day $3;
}

access_log logs/access-$year-$month-$day.log main;
```
if 只能用在server location段
```
log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
                  '$status $body_bytes_sent "$http_referer" '
                  '"$http_user_agent" "$http_x_forwarded_for"';

map $time_iso8601 $logdate {
  '~^(?<ymd>\d{4}-\d{2}-\d{2})' $ymd;
  default                       'date-not-found';
}

access_log logs/access-$logdate.log main;
open_log_file_cache max=10;
```

map 可以使用在http中，配置open_log_file_cache可以提高日志效率

## 使用logrotate分割日志

```
/data/nginx/logs/*.log
/data/logs/nginx/*.log 
{
  #copytruncate
  create 644 root root
  #su root webadmin
  daily
  rotate 5
  olddir /data/nginx/logs/backup/
  missingok
  dateext
  dateformat -%Y%m%d
  compress
  notifempty
  sharedscripts
  postrotate
    [ -e /var/run/nginx.pid ] && kill -USR1 `cat /var/run/nginx.pid`
  endscript
}
```



## 使用shell脚本分割日志
```
#!/bin/bash

nginx_path=/usr/local/nginx/sbin/nginx
nginx_conf=/usr/local/nginx/conf/nginx.conf
nginx_log=/usr/local/nginx/logs
date_time=$(date +%Y%m%d-%H%M%S)

mv ${nginx_log}/error.log ${nginx_log}/error_${date_time}.log
mv ${nginx_log}/access.log ${nginx_log}/access_${date_time}.log

# reopening the log files
$nginx_path -c $nginx_conf -s reopen
```
