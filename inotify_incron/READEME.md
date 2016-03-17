#inotify#
```
http://man7.org/linux/man-pages/man7/inotify.7.html
https://en.wikipedia.org/wiki/Inotify
```
Inotify (inode notify) is a Linux kernel subsystem that acts to extend filesystems to notice changes to the filesystem, and report those changes to applications.It replaces an earlier facility, dnotify, which had similar goals.

查看系统是否支持inotify
```
ls -l /proc/sys/fs/inotify/ 有下面文件即是支持

total 0
  -rw-r--r-- 1 root root 0 Oct  9 09:36 max_queued_events
  -rw-r--r-- 1 root root 0 Oct  9 09:36 max_user_instances
  -rw-r--r-- 1 root root 0 Oct  9 09:36 max_user_watches
```
##inotify-tools##
`https://github.com/rvoicilas/inotify-tools`

inotify tools 提供接口访问系统的inotify  
inotify tools 提供了2个工具：  
inotifywait 监控文件，目录的变化  
inotifywatch 统计文件系统的访问次数  

##incron incrond incrontab##
incrontab tables for driving inotify cron(incron)  
incron是inotify的cron系统，与操作系统的cron一样，包含一个守护进程 incrond 和 tables incrontab  
安装 yum install incron  
编辑 incrontab -e  
```
<path> <mask> <command>
/home/root IN_ALL_EVENTS echo "$% $#"
选项说明:
<path>：监控的文件或者目录
<mask>：监控的事件
<command>：command可以是系统命令，也可以是脚本，不能用系统的重定向，除非重定向写在脚本中。
<Command>中还可以使用下面的这些变量：
$@：代表<path>，监控对象
$#：发生系统事件的对象（例如监控了某个文件夹，其下的某个文件发生了变化，那么$#就代表了该文件名）
$%：代表<mask>，即发生的事件
```
日志记录在 /var/log/cron  
centos 7 启动   
systemctl enable incrond.service  
systemctl start incrond.service   
systemctl status incrond.service   

##fswatch##

MAC OSX可以使用的工具



