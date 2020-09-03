## 显示selinux

ps axZ

ps -ZC httpd

ls -Z /var/www

## 更改模式

getenforce

setenforce 1 0 Enforcing Permissive

/etc/selinux/config

## 文件selinux上下文

mv文件将保留文件原始标签

cp文件则继承目标目录的标签

```
system_u:object_r:httpd_sys_content_t:s0 index.html
unconfined_u:object_r:httpd_sys_content_t:s0 file2
用户         :角色     : 类型               :级别
```

## 更改上下文

semanage fcontext、restorecon和chcon

使用semanage fcontext声明文件的默认标签

然后使用restorecon将上下文应用于文件

chcon 不会保存到selinux上下文数据库中，会失效

```
chcon -t httpd_sys_content_t /virtual/        #更改类型

restorecon -v /virtual/
Relabeled /virtual from unconfined_u:object_r:httpd_sys_content_t:s0 to unconfined_u:object_r:default_t:s0    #restorecon 更改为默认值
```

```
[root@vm213 ~]# ll -Zd /virtual/
drwxr-xr-x. 2 root root unconfined_u:object_r:default_t:s0 24 Sep  2 10:40 /virtual/
[root@vm213 ~]# ll -Z /virtual/
total 0
-rw-r--r--. 1 root root unconfined_u:object_r:default_t:s0 0 Sep  2 10:40 index.html
[root@vm213 ~]# semanage fcontext -a -t httpd_sys_content_t '/virtual(/.*)?'
[root@vm213 ~]# restorecon -RFvv /virtual/
Relabeled /virtual from unconfined_u:object_r:default_t:s0 to system_u:object_r:httpd_sys_content_t:s0
Relabeled /virtual/index.html from unconfined_u:object_r:default_t:s0 to system_u:object_r:httpd_sys_content_t:s0
[root@vm213 ~]# ls -Zd /virtual/
system_u:object_r:httpd_sys_content_t:s0 /virtual/
[root@vm213 ~]# ls -Z /virtual/
system_u:object_r:httpd_sys_content_t:s0 index.html
```

## selinux 布尔值

```
getsebool -a  #列出布尔值及其状态
getsebool httpd_enable_homedirs  # 列出某一条
setsebool httpd_enable_homedirs on
setsebool -P httpd_enable_homedirs on #重启后保留

[root@vm213 ~]# semanage boolean -l | grep httpd_enable_homedirs
httpd_enable_homedirs          (on   ,  off)  Allow httpd to enable homedirs
[root@vm213 ~]# setsebool -P httpd_enable_homedirs on
[root@vm213 ~]# semanage boolean -l | grep httpd_enable_homedirs
httpd_enable_homedirs          (on   ,   on)  Allow httpd to enable homedirs

```

## 实例

```
touch /root/file3
mv /root/file3 /var/www/html
curl http://localhost/file3

tail /var/log/audit/audit.log
type=AVC msg=audit(1599016855.243:570): avc:  denied  { getattr } for  pid=35556 comm="httpd" path="/var/www/html/file3" dev="dm-0" ino=101677487 scontext=system_u:system_r:httpd_t:s0 tcontext=unconfined_u:object_r:admin_home_t:s0 tclass=file permissive=0

tail /var/log/messages
Sep  2 11:21:00 vm213 setroubleshoot[36189]: failed to retrieve rpm info for /var/www/html/file3
Sep  2 11:21:00 vm213 setroubleshoot[36189]: SELinux is preventing httpd from getattr access on the file /var/www/html/file3. For complete SELinux messages run: sealert -l 20052e4c-da91-4ea6-8ad1-6aec3ea4dfb8
Sep  2 11:21:00 vm213 platform-python[36189]: SELinux is preventing httpd from getattr access on the file /var/www/html/file3.#012#012*****  Plugin restorecon (99.5 confidence) suggests   ************************#012#012If you want to fix the label. #012/var/www/html/file3 default label should be httpd_sys_content_t.#012Then you can run restorecon. The access attempt may have been stopped due to insufficient permissions to access a parent directory in which case try to change the following command accordingly.#012Do#012# /sbin/restorecon -v /var/www/html/file3#012#012*****  Plugin catchall (1.49 confidence) suggests   **************************#012#012If you believe that httpd should be allowed getattr access on the file3 file by default.#012Then you should report this as a bug.#012You can generate a local policy module to allow this access.#012Do#012allow this access for now by executing:#012# ausearch -c 'httpd' --raw | audit2allow -M my-httpd#012# semodule -X 300 -i my-httpd.pp#012

sealert -l 20052e4c-da91-4ea6-8ad1-6aec3ea4dfb8   #sealert提供额外的信息
```

ausearch -m AVC -ts recent  # -m avc类型 -ts 根据时间查找 /var/log/audit/audit.log