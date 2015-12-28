./configure --prefix=/usr/local/zabbix-2.4   \
	--enable-server                  \
    --enable-proxy                   \
	--enable-agent                   \
	--with-mysql                     \
	--with-net-snmp                  \
	--with-libcurl                   \
	--with-libxml2

make && make install


./configure --prefix=/usr/local/zabbix/ --enable-proxy \
    --enable-agent  \ 
    --with-mysql    \
    --with-net-snmp \
    --with-libcurl   \
    --with-libxml2