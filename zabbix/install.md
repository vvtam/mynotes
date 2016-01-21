##zabbix install##
###zabbix server###
./configure --prefix=/usr/local/zabbix --enable-server --enable-proxy --enable-agent --with-mysql --with-net-snmp --with-libcurl --with-libxml2
make && make install
###zabbix proxy###
./configure --prefix=/usr/local/zabbix --enable-proxy --enable-agent --with-mysql --with-net-snmp --with-libcurl --with-libxml2
make && make install
###zabbix agent###
./configure --prefix=/usr/local/zabbix --enable-agent --with-mysql --with-net-snmp --with-libcurl --with-libxml2 --enable-ipv6
make && make install
