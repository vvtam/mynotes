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
```
支持的事件
IN_ACCESS,
IN_MODIFY,
IN_ATTRIB,
IN_CLOSE_WRITE,
IN_CLOSE_NOWRITE,
IN_OPEN,
IN_MOVED_FROM,
IN_MOVED_TO,
IN_CREATE,
IN_DELETE,
IN_DELETE_SELF,
IN_CLOSE,
IN_MOVE,
IN_ONESHOT,
IN_ALL_EVENTS,
IN_DONT_FOLLOW,
IN_ONLYDIR,
IN_MOVE_SELF
```
日志记录在 /var/log/cron  
centos 7 启动   
systemctl enable incrond.service  
systemctl start incrond.service   
systemctl status incrond.service   

##fswatch##

MAC OSX可以使用的工具

```
inotifywait 3.14
Wait for a particular event on a file or set of files.
Usage: inotifywait [ options ] file1 [ file2 ] [ file3 ] [ ... ]
Options:
	-h|--help     	Show this help text.
	@<file>       	Exclude the specified file from being watched.
	--exclude <pattern>
	              	Exclude all events on files matching the
	              	extended regular expression <pattern>.
	--excludei <pattern>
	              	Like --exclude but case insensitive.
	-m|--monitor  	Keep listening for events forever.  Without
	              	this option, inotifywait will exit after one
	              	event is received.
	-d|--daemon   	Same as --monitor, except run in the background
	              	logging events to a file specified by --outfile.
	              	Implies --syslog.
	-r|--recursive	Watch directories recursively.
	--fromfile <file>
	              	Read files to watch from <file> or `-' for stdin.
	-o|--outfile <file>
	              	Print events to <file> rather than stdout.
	-s|--syslog   	Send errors to syslog rather than stderr.
	-q|--quiet    	Print less (only print events).
	-qq           	Print nothing (not even events).
	--format <fmt>	Print using a specified printf-like format
	              	string; read the man page for more details.
	--timefmt <fmt>	strftime-compatible format string for use with
	              	%T in --format string.
	-c|--csv      	Print events in CSV format.
	-t|--timeout <seconds>
	              	When listening for a single event, time out after
	              	waiting for an event for <seconds> seconds.
	              	If <seconds> is 0, inotifywait will never time out.
	-e|--event <event1> [ -e|--event <event2> ... ]
		Listen for specific event(s).  If omitted, all events are
		listened for.

Exit status:
	0  -  An event you asked to watch for was received.
	1  -  An event you did not ask to watch for was received
	      (usually delete_self or unmount), or some error occurred.
	2  -  The --timeout option was given and no events occurred
	      in the specified interval of time.

Events:
	access		file or directory contents were read
	modify		file or directory contents were written
	attrib		file or directory attributes changed
	close_write	file or directory closed, after being opened in
	           	writeable mode
	close_nowrite	file or directory closed, after being opened in
	           	read-only mode
	close		file or directory closed, regardless of read/write mode
	open		file or directory opened
	moved_to	file or directory moved to watched directory
	moved_from	file or directory moved from watched directory
	move		file or directory moved to or from watched directory
	create		file or directory created within watched directory
	delete		file or directory deleted within watched directory
	delete_self	file or directory was deleted
	unmount		file system containing file or directory unmounted
```
