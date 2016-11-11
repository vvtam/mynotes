#update openssh#

##升级zlib##
```
http://zlib.net/zlib-1.2.8.tar.gz
tar -zxvf zlib-1.2.8.tar.gz
cd zlib-1.2.8
./configure --shared
make
make test
make install
```

##升级openssl##
```
https://www.openssl.org/source/openssl-1.0.2j.tar.gz
cd openssl-1.0.2j/
./config shared  (默认安装路径/usr/local/ssl)
make
make test
make install
```
```
备份openssl
mv /usr/bin/openssl /usr/bin/openssl.bak
mv /usr/include/openssl /usr/include/openssl.bak

软链接
ln -s /usr/local/ssl/bin/openssl /usr/bin/openssl
ln -s /usr/local/ssl/include/openssl /usr/include/openssl

编辑/etc/ld.so.conf加入/usr/local/ssl/lib
ldconfig让配置文件生效

查看当前openssl版本信息
openssl version -a
```

##升级openssh##
```
http://www.openssh.com/portable.html
tar zxvf openssh-7.3p1.tar.gz
cd openssh-7.3p1/
修改kex.c文件
debug("SSH2_MSG_KEXINIT received"); 附近加
ssh_dispatch_set(ssh, SSH2_MSG_KEXINIT, NULL);

编译安装
./configure --prefix=/usr/local/ssh73p1 --sysconfdir=/usr/local/ssh73p1/conf --with-openssl-includes=/usr/local/ssl/include --with-ssl-dir=/usr/local/ssl --with-privsep-path=/var/emptysshd73p1 --with-privsep-user=sshd --with-zlib --with-ssl-engine --with-md5-passwords --disable-etc-default-login
make
make install

备份
mv /usr/sbin/sshd /usr/sbin/sshd.bak
软连接
ln -s /usr/local/ssh73p1/sbin/sshd /usr/sbin/sshd

修改配置
/usr/local/ssh73p1/conf

重启服务(centos7)
systemctl restart sshd
```
