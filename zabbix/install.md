##zabbix install##
###zabbix server###
./configure --prefix=/usr/local/zabbix --enable-server --enable-proxy --enable-agent --with-mysql --with-net-snmp --with-libcurl --with-libxml2

make install

```
安装一些依赖
ln -s libmysqlclient.so.18.0.0 libmysqlclient.so
yum install mariadb-devel（或者mysql-devel）
um install libxml2.x86_64 libxml2-devel.x86_64
yum install libcurl libcurl-devel
```
make && make install
###zabbix proxy###
./configure --prefix=/usr/local/zabbix --enable-proxy --enable-agent --with-mysql --with-net-snmp --with-libcurl --with-libxml2
make && make install
###zabbix agent###
./configure --prefix=/usr/local/zabbix --enable-agent --with-mysql --with-net-snmp --with-libcurl --with-libxml2 --enable-ipv6
make && make install
