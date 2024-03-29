## 安装环境

```
# cat /etc/redhat-release 
CentOS Linux release 7.9.2009 (Core) 

# uname -a
Linux centos7 3.10.0-1160.el7.x86_64 #1 SMP Mon Oct 19 16:18:59 UTC 2020 x86_64 x86_64 x86_64 GNU/Linux

# rpm -qa cobbler
cobbler-2.6.10-1.el7.noarch
```

## 安装过程

### 增加repo源

rpm -ivh http://mirrors.aliyun.com/epel/epel-release-latest-7.noarch.rpm

wget -O /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-7.repo

### 安装Cobbler及相关软件

yum -y install httpd xinetd tftp-server dnsmasq rsync syslinux
yum -y install cobbler fence-agents pykickstart cobbler-web

### 配置
#### 关闭selinux
```
# vi /etc/selinux/config 
SELINUX=disabled

# 获取selinux状态
# getenforce
```

#### 关闭防火墙
```
systemctl stop firewalld
systemctl disable firewalld 
```
#### 生成默认密码
```
# 生成系统安装后，root的密码 (默认密码为 cobbler)
# 格式 openssl passwd -1 -salt 'random-phrase-here' 'your-password-here'
# 其中 random-phrase-here 为干扰码

# openssl passwd -1 -salt 'KoGvJXV2AuBNFeH' 'cobbler'                                 
$1$fDdHOmOo$7FSWHeKI9UrXQ4b.07w031
```
#### 配置cobbler
```
# 修改Cobbler配置/etc/cobbler/settings
manage_dhcp：1
manage_dns：1
manage_tftpd：1
restart_dhcp：1
restart_dns：1
next_server：<服务器的 IP 地址>
server：<服务器的 IP 地址>
default_password_crypted: "$1$KoGvJXV2$nWIwUgQNSaRrYJ.xL8QJh0"

# 修改 modules，使用dnsmasq作为DHCP、DNS服务器
# vi /etc/cobbler/modules.conf
[dns]
module = manage_dnsmasq

[dhcp]
module = manage_dnsmasq

[tftpd]
module = manage_in_tftpd

# 修改dnsmasq配置文件 /etc/cobbler/dnsmasq.template
# Cobbler generated configuration file for dnsmasq
# $date
#

# resolve.conf .. ?
#no-poll
#enable-dbus
read-ethers
addn-hosts = /var/lib/cobbler/cobbler_hosts

dhcp-range=192.168.1.5,192.168.1.200
dhcp-option=66,$next_server
dhcp-lease-max=1000
dhcp-authoritative
dhcp-boot=pxelinux.0
dhcp-boot=net:normalarch,pxelinux.0
dhcp-boot=net:ia64,$elilo

$insert_cobbler_system_definitions



# TFTP配置
# cat /etc/xinetd.d/tftp 
# default: off
# description: The tftp server serves files using the trivial file transfer \
#       protocol.  The tftp protocol is often used to boot diskless \
#       workstations, download configuration files to network-aware printers, \
#       and to start the installation process for some operating systems.
service tftp
{
        socket_type             = dgram
        protocol                = udp
        wait                    = yes
        user                    = root
        server                  = /usr/sbin/in.tftpd
        server_args             = -s /var/lib/tftpboot
        disable                 = no
        per_source              = 11
        cps                     = 100 2
        flags                   = IPv4
}

systemctl enable xinetd.service
systemctl enable tftp.socket
systemctl enable tftp.service

# 配置httpd
cd /etc/httpd/conf.d/
#移除并备份conf文件，目的不显示测试页面
mv autoindex.conf autoindex.conf.bak
mv userdir.conf userdir.conf.bak
mv welcome.conf welcome.conf.bak


# 启动httpd、Cobbler

systemctl enable httpd.service
systemctl enable cobblerd.service

reboot

# Cobbler检查，会检测到一些错误，根据提示解决
cobbler check

# Cobbler配置应用
cobbler sync

# 查看相关应用是否启动
ss -naltu


# 准备安装文件
# 导入iso文件
mount -t iso9660 -o loop,ro CentOS-7-x86_64-DVD-2009.iso /mnt/centos/
cobbler import --name=centos7 --path=/mnt/centos --arch=x86_64

# 查看导入结果
cobbler distro list
	centos7-x86_64
cobbler distro report
cobbler profile report

# 添加kickstart配置文件
# cp /var/lib/cobbler/kickstarts/centos7.ks
timezone Asia/Shanghai --isUtc
lang en_US.UTF-8 --addsupport=zh_CN.UTF-8

# 添加账号
# user --name=<username> [--groups=<list>] [--homedir=<homedir>] [--password=<password>] [--iscrypted] [--shell=<shell>] [--uid=<uid>]
user --name="xx_ops" --iscrypted="$1$KoGvJXV2$nWIwUgQNSaRrYJ.xL8QJh0" --uid=1000


# Allow anaconda to partition the system as needed
# autopart

# Partition clearing information
clearpart --all --initlabel
# Disk partitioning information
part / --asprimary --fstype="xfs" --size=204800
part /boot --asprimary --fstype="xfs" --size=1024
part swap --asprimary --fstype="swap" --size=4096
# kvm
part /vm --asprimary --fstype="xfs" --grow --size=1
# data
part /data --asprimary --fstype="xfs" --grow --size=1

#LVM-data
part /boot --fstype="xfs" --size=1024
part swap --fstype="swap" --size=4096
part pv.01 --size=1 --grow
volgroup centos pv.01
logvol  / --fstype="xfs" --vgname=centos  --size=2048  --name=root
logvol  /data  --fstype="xfs" --vgname=centos  --size=1  --grow  --name=data


#LVM-kvm
part /boot --fstype="xfs" --size=1024
part swap --fstype="swap" --size=4096
part pv.01 --size=1 --grow
volgroup centos pv.01
logvol  / --fstype="xfs" --vgname=centos  --size=2048  --name=root
logvol  /vm  --fstype="xfs" --vgname=centos  --size=1  --grow  --name=vm







# cobbler profile add --name=Fedora17-xfce --ksmeta='desktop_pkg_group=@xfce-desktop' --kickstart=/var/lib/cobbler/kickstarts/example.ks --parent=centos7mini2-x86_64
# cobbler profile add --name=centos-data --kickstart=/var/lib/cobbler/kickstarts/jxl_data.ks --parent=centos7mini2-x86_64

# 修改kickstart文件
cobbler profile edit --name=centos7mini-x86_64 --kickstart=/var/lib/cobbler/kickstarts/jxl_data.ks

# 验证kickstart文件内容
cobbler profile getks --name=centos7mini-x86_64

# 配置需要安装的机器 
# 针对MAC为00:0C:29:48:30:63的机器安装
cobbler system add --name=test --profile=centos7mini-x86_64 --interface=eno16777736 --mac=00:0C:29:48:30:63 --ip-address=192.168.211.11 --netmask=255.255.255.0 --static=1 --dns-name=test.mydomain.com --gateway=192.168.211.1 --hostname=test.mydomain.com

cobbler system report


#######
# 让配置生效
cobbler sync

#######注意################
# 检查 dnsmasq dhcp-range是否正确，因为cobbler sync 会修改
grep "range" /etc/dnsmasq.conf
dhcp-range=192.168.211.10,192.168.211.20

# 修改/etc/dnsmasq.conf 后需要重启dnsmasq
systemctl restart dnsmasq.service



##############################
# 安装Cobbler Web 界面

yum -y install cobbler-web
# 修改授权
# /etc/cobbler/modules.conf 
[authentication]
module = authn_pam

[authorization]
module = authz_ownership

# 添加Cobbler_web 账号
# useradd web && passwd web

# 将 账号 添加到Cobbler_web admins组
# cat /etc/cobbler/users.conf 
[admins]
admin = ""
cobbler = ""
web = ""

# 重启服务
service cobblerd restart
service httpd restart

# 登录WEB（注意使用https）
https://192.168.211.131/cobbler_web/


# Cobbler 子命令介绍
cobbler check         #检查cobbler配置
cobbler sync          #步配置到dhcp pxe和数据目录
cobbler list          #列出所有的cobbler元素
cobbler import        #导入安装的系统光盘镜像
cobbler report        #列出各元素的详细信息
cobbler distro        #查看导入的发行版系统信息
cobbler profile       #查看配置信息
cobbler system        #查看添加的系统信息
cobbler reposync      #同步yum仓库到本地

cobbler repo add --name=CentOS-7-x86_64 --mirror=http://mirrors.aliyun.com/centos/7/os/x86_64/
cobbler reposync


# 参考文档
# Cobbler官网
http://cobbler.github.io/manuals/quickstart/
http://cobbler.github.io/manuals/2.6.0/
# dnsmasq设置
http://debugo.com/dnsmasq/
# 使用 Cobbler 自动化和管理系统安装
http://www.ibm.com/developerworks/cn/linux/l-cobbler/
# Cobbler自动化工具同时批量部署CentOS7及CentOS6.5
http://www.tuicool.com/articles/YZN3qi
#kickstart配置文件详解
http://blog.chinaunix.net/uid-17240700-id-2813881.html
```