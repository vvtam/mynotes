## 基本用法
```
*/1 * * * * root /usr/bin/flock -xn /tmp/npss3.tmp /usr/local/bin/webbench -c 200 -t 60 "http://192.168.95.76:51002/nl.ts?id=RANDOM&ndi=device_id001&nn_from_epg_server=1"
*/1 * * * * root cd /root/nn_npss.3.8.30/201002.run/log/ && cat log_info* > temp && grep monitor ./temp >> ./xxx.txt
#nmon per one hour
0 * * * * root cd /root/ && /usr/bin/nmon -f -t -s30 -c120

special time specification nickname
@reboot    :    Run once after reboot.
@yearly    :    Run once a year, ie.  "0 0 1 1 *".
@annually  :    Run once a year, ie.  "0 0 1 1 *".
@monthly   :    Run once a month, ie. "0 0 1 * *".
@weekly    :    Run once a week, ie.  "0 0 * * 0".
@daily     :    Run once a day, ie.   "0 0 * * *".
@hourly    :    Run once an hour, ie. "0 * * * *".
```
```
## cron.daily

/etc/cron.daily/ 

/etc/anacrontab 定义时间

# /etc/anacrontab: configuration file for anacron

# See anacron(8) and anacrontab(5) for details.

SHELL=/bin/sh
PATH=/sbin:/bin:/usr/sbin:/usr/bin
MAILTO=root
# the maximal random delay added to the base delay of the jobs
RANDOM_DELAY=45
# the jobs will be started during the following hours only
START_HOURS_RANGE=3-22

#period in days   delay in minutes   job-identifier   command
1	5	cron.daily		nice run-parts /etc/cron.daily
7	25	cron.weekly		nice run-parts /etc/cron.weekly
@monthly 45	cron.monthly		nice run-parts /etc/cron.monthly

```

/etc/anacrontab会确保重要的作业始终运行，如果因为关机，休眠等意外跳过，系统就绪后会执行作业，crond在启动anacrontab作业的时候，也会更新他们的时间戳

tmpwatch 删tmp 文件

## at atq atd

```
echo "date >> data.txt" | at now +2min #2min后执行
```

```
[root@vm213 ~]#at -q g teatime
warning: commands will be executed using /bin/sh
at> echo "some xxx" >> dir/file
at> Ctrl+d
job 3 at Wed Sep  2 16:00:00 2020

[root@vm213 ~]#at -q b 16:05
warning: commands will be executed using /bin/sh
at> echo "some xxx" >> dir/file
at> Ctrl+d
job 3 at Wed Sep  1 16:05:00 2020

```

at -c xx 检查

### atd守护进程

### 时间参数

now +5min

teatime tomorrow

noon +4 days

5pm august 3 2021

### atq at -l 待处理

watch atq

### atrm 删除作业

## systemd 定时器

sysstat 软件包

/usr/lib/systemd/system/sysstat-collect.timer

```
[Timer]
OnCalendar=*:00/10 #每十分钟
OnCalendar=2020-10-*12:35,37,39:16 #2020十月每天的12:35:16 12:37:16 12:39:16 

OnUnitActiveSec=15min

```

在 /etc/systemd/system/ 创建副本，因为/usr/lib/systemd/system/ 下面的文件更新是可能被覆盖

systemctl daemon-reload 更改

systemctl enable --now <>.timer

### systemd-tmpfiles

systemd-tmpfiles-clean.timer 定时器

/usr/lib/tmpfiles.d/*.conf

/run/tmpfiles.d/*.conf

/etc/tmpfiles.d/*.conf

查看

systemctl cat systemd-tmpfiles-clean.timer

配置文件格式

类型   路径    模式  UID   GID   期限 参数

d  /run/xxx   0755  root  root -

D  /home/xxx 0700 stu   stu    1d

L /run/xxx  -      root root - /etc/fstab #符号连接