./configure --prefix=/usr/local/zabbix-2.4   \
	--enable-server                  \
	--enable-agent                   \
	--with-mysql                     \
	--with-net-snmp                  \
	--with-libcurl                   \
	--with-libxml2

make && make install