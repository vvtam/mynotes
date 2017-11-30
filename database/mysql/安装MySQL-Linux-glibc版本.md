# 安装MySQL-Linux-glibc版本

## 下载
[下载地址](https://dev.mysql.com/downloads/mysql/)

选者Linux-Generic版本下载

## 安装
解压到 /usr/local/mysql

添加mysql用户名和用户组
```
groupadd mysql
useradd -r -g mysql mysql
```
根据/etc/my.cnf建立各种目录，并赋予mysql.mysql权限

可以把mysql目录加入环境变量，比如~/.bashrc

`export PATH=$PATH:/usr/local/mysql/bin`

初始化
`mysqld --initialize --user=mysql --basedir=/usr/local/mysql --datadir=/data/mysql`

生成的初始密码可以在数据目录的error日志查看

初次登录会提示修改密码

## 加入到服务(自动启动)
系统用的CentOS
```
cp /usr/local/mysql/support-files/mysql.server /etc/init.d/mysql.server
chkconfig --add mysql.server
默认是2345级别自动启动？
```
