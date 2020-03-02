# php
## pecl在线安装扩展

/usr/local/php/bin/pecl install Extension

## 源码编译安装扩展

比如 ldap
```
进入php源码目录 php/ext/ldap
/usr/local/php/bin/phpize
./configure  --with-php-config=/usr/local/php/bin/php-config  --with-ldap
make && make instll
修改php.ini配置文件

imap  
error: utf8_mime2text() has new signature, but U8T_CANONICAL is missing  
yum -y install epel-release; yum -y install uw-imap-devel  
./configure --with-kerberos --with-imap-ssl  

```
## 问题
_open_
version php-7.0.5 centos 7.2
php-fpm监听的是sock文件，位置为/dev/shm/ (内存)，访问报502，/dev/shm下的sock文件被莫名删除


