#zabbix install#
##zabbix server##
./configure --prefix=/usr/local/zabbix --enable-server --enable-proxy --enable-agent --with-mysql --with-net-snmp --with-libcurl --with-libxml2

make install

```
安装一些依赖
ln -s libmysqlclient.so.18.0.0 libmysqlclient.so
yum install mariadb-devel（或者mysql-devel）
um install libxml2.x86_64 libxml2-devel.x86_64
yum install libcurl libcurl-devel
```
##zabbix proxy##
./configure --prefix=/usr/local/zabbix --enable-proxy --enable-agent --with-mysql --with-net-snmp --with-libcurl --with-libxml2
make install
##zabbix agent##
./configure --prefix=/usr/local/zabbix --enable-agent --with-mysql --with-net-snmp --with-libcurl --with-libxml2 --enable-ipv6
make install

##mysql##
```
shell> mysql -uroot -p<password>
mysql> create database zabbix character set utf8 collate utf8_bin;
mysql> grant all privileges on zabbix.* to zabbix@localhost identified by '<password>';
mysql> quit;
shell> cd database/mysql
shell> mysql -uzabbix -p<password> zabbix < schema.sql
# stop here if you are creating database for Zabbix proxy
shell> mysql -uzabbix -p<password> zabbix < images.sql
shell> mysql -uzabbix -p<password> zabbix < data.sql
```
修改zabbix web上面的配置  
修改zabbix server 上的配置  
以上都需要配置数据库信息 

 
