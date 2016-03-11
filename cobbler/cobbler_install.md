#cobbler install#
##安装环境##
```
cat /etc/redhat-release
CentOS Linux release 7.2.1511 (Core)

uname -a
Linux localhost.localdomain 3.10.0-327.10.1.el7.x86_64 #1 SMP Tue Feb 16 17:03:50 UTC 2016 x86_64 x86_64 x86_64 GNU/Linux

rpm -qa | grep cobbler
cobbler-2.6.11-1.el7.x86_64

cobbler在epel源
可以用阿里云的repo源
```
##安装包##
```
yum -y install httpd xinetd tftp-server dnsmasq rsync syslinux
yum -y install cobbler fence-agents pykickstart
```
##配置##
###关闭selinux###
```
vim /etc/selinux/config
SELINUX=disabled
重启生效
```
###关闭firewall（iptables）或者配置端口###
```
systemctl stop firewalld
systemctl disable firewalld
如果不关闭请添加相应规则，开放端口
```
###配置cobbler###
```
安装系统后默认密码
```