#!/bin/bash
#zabbix version 4.0.5

yum -y install net-tools

ZABBIX_VERSION="zabbix-4.0.5"
SERVER_IP="ip"
AGENT_IP=$(ifconfig eth0 | grep netmask | awk '{print $2}') #eth0 need ifconfig
WORK_DIR="/root"
WWW_ROOT="/data/wwwroot/zabbix4"

yum -y install wget
cd $WORK_DIR
wget -O $ZABBIX_VERSION.tar.gz "https://sourceforge.net/projects/zabbix/files/ZABBIX%20Latest%20Stable/4.0.3/zabbix-4.0.3.tar.gz/download"

SERVER_INSTALL() {
	if [ -s /usr/local/sbin/zabbix_server ]; then
		echo "zabbix server already installed"
	else
		yum -y install curl curl-devel net-snmp net-snmp-devel perl-DBI mariadb-devel #mariadb-devel for mysql library
		groupadd --system zabbix
		useradd --system -g zabbix -d /usr/lib/zabbix -s /sbin/nologin -c "Zabbix Monitoring System" zabbix

		cd $WORK_DIR
		tar xzf $ZABBIX_VERSION.tar.gz
		cd $ZABBIX_VERSION
		./configure --enable-server --enable-agent --with-mysql --enable-ipv6 --with-net-snmp --with-libcurl --with-libxml2 && make install

		cd $WORK_DIR/$ZABBIX_VERSION
		cp misc/init.d/tru64/{zabbix_agentd,zabbix_server} /etc/init.d/ && chmod o+x /etc/init.d/zabbix_*
		mkdir -p $WWW_ROOT/zabbix/ && cp -r frontends/php/* $WWW_ROOT/zabbix/

		#config zabbix server
		cat >/usr/local/etc/zabbix_server.conf <<EOF
LogFile=/tmp/zabbix_server.log
DBHost=$SERVER_IP
DBName=zabbix
DBUser=zabbix
DBPassword=zabbix
EOF
		#config zabbix agentd
		cat >/usr/local/etc/zabbix_agentd.conf <<EOF
LogFile=/tmp/zabbix_agentd.log
Server=$SERVER_IP
ServerActive=$SERVER_IP
Hostname=$AGENT_IP 
EOF
		cat >>/etc/rc.d/rc.local <<EOF
/etc/init.d/zabbix_agentd start
/etc/init.d/zabbix_server start
/usr/local/sbin/zabbix_server -c /usr/local/etc/zabbix_server.conf
/usr/local/sbin/zabbix_agentd -c /usr/local/etc/zabbix_agentd.conf
EOF
		#start zabbix agentd
		/etc/init.d/zabbix_server restart
		/etc/init.d/zabbix_agentd restart
		chmod +x /etc/rc.d/rc.local
	fi
}

AGENT_INSTALL() {
	if [ -s /usr/local/sbin/zabbix_agentd ]; then
		echo "zabbix agent already installed"
	else
		groupadd --system zabbix
		useradd --system -g zabbix -d /usr/lib/zabbix -s /sbin/nologin -c "Zabbix Monitoring System" zabbix

		cd $WORK_DIR
		tar xzf $ZABBIX_VERSION.tar.gz
		cd $ZABBIX_VERSION
		./configure --enable-agent && make install

		cd $WORK_DIR/$ZABBIX_VERSION
		cp misc/init.d/tru64/zabbix_agentd /etc/init.d/zabbix_agentd && chmod o+x /etc/init.d/zabbix_agentd

		#config zabbix agentd
		cat >/usr/local/etc/zabbix_agentd.conf <<EOF
LogFile=/tmp/zabbix_agentd.log
Server=$SERVER_IP
ServerActive=$SERVER_IP
Hostname=$AGENT_IP
EOF
		cat >>/etc/rc.d/rc.local <<EOF
/etc/init.d/zabbix_agentd start
/usr/local/sbin/zabbix_agentd -c /usr/local/etc/zabbix_agentd.conf
EOF
		#startzabbix agentd
		chmod +x /etc/rc.d/rc.local
		/etc/init.d/zabbix_agentd restart
	fi
}

echo "Type yes to install Zabbix server and Agent"
echo "Type no will install Agent"
read -p "Type others will exit: " USER_INPUT
#if [ $USER_INPUT == "s" -o $USER_INPUT == "y" ]; then
if [ $USER_INPUT == "yes" ]; then
	SERVER_INSTALL
elif [ $USER_INPUT == "no" ]; then
	AGENT_INSTALL
else
    exit;
fi
