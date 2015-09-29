##To Increase the File Descriptor Limit (Linux)##

1. Display the current hard limit of your machine.
The hard limit is the maximum server limit that can be set without tuning the kernel parameters in proc file system.    

$ ulimit -aH
core file size (blocks)       unlimited
data seg size (kbytes)        unlimited
file size (blocks)            unlimited
max locked memory (kbytes)    unlimited
max memory size (kbytes)      unlimited
open files                    1024
pipe size (512 bytes)         8
stack size (kbytes)           unlimited
cpu time (seconds)            unlimited
max user processes            4094
virtual memory (kbytes)       unlimited    

2. Edit the /etc/security/limits.conf and add the lines:    
*     soft   nofile  1024
*     hard   nofile  65535       
3. Edit the /etc/pam.d/login by adding the line:    
session required /lib/security/pam_limits.so     
4. Use the system file limit to increase the file descriptor limit to 65535.    
The system file limit is set in /proc/sys/fs/file-max .    
echo 65535 > /proc/sys/fs/file-max       
5. Use the ulimit command to set the file descriptor limit to the hard limit specified in /etc/security/limits.conf.
ulimit -n unlimited         
6. Restart your system.

1.修改file-max

# echo  6553560 > /proc/sys/fs/file-max  //sysctl -w "fs.file-max=34166"，前面2种重启机器后会恢复为默认值
或
# vim /etc/sysctl.conf, 加入以下内容，重启生效
fs.file-max = 6553560
 
2.修改ulimit的open file，系统默认的ulimit对文件打开数量的限制是1024

# ulimit -HSn 65535  //这只是在当前终端有效，退出之后，open files又变为默认值。当然也可以写到/etc/profile中，因为每次登录终端时，都会自动执行/etc/profile 或
# vim /etc/security/limits.conf  //加入以下配置，重启即可生效
* soft nofile 65535 
* hard nofile 65535

为了让一个程序的open files数目扩大，可以在启动脚本前面加上ulimit -HSn 102400命令。但当程序是一个daemon时，可能这种方法无效，因为没有终端。

如果某项服务已经启动，再动态调整ulimit是无效的，特别是涉及到线上业务就更麻烦了。
这时，可以考虑通过修改/proc/’程序pid’/limits来实现动态修改！！！