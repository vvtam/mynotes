groupadd --system zabbix && \
useradd --system -g zabbix -d /usr/lib/zabbix -s /sbin/nologin -c "Zabbix Monitoring System" zabbix

./configure --enable-server --enable-agent --with-mysql --enable-ipv6 --with-net-snmp --with-libcurl --with-libxml2 && \
make install

./configure --enable-agent && \
make install


edit the Zabbix agent configuration file /usr/local/etc/zabbix_agentd.conf

edit the Zabbix server configuration file /usr/local/etc/zabbix_server.conf

if you have installed a Zabbix proxy, edit the proxy configuration file /usr/local/etc/zabbix_proxy.conf

create database for zabbix
