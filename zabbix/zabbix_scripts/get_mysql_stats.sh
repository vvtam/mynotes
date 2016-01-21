#!/bin/sh

flag=$1
Mysql_user="xxxx"
Mysql_pass="xxxx"
mysql -u${Mysql_user} -p${Mysql_pass} -h127.0.0.1  -e "show global status">/tmp/mysql_stats.txt








function get_qps(){
	Questions=`cat /tmp/mysql_stats.txt|grep Questions|awk '{print $2}'`
#	uptime=`cat /tmp/mysql_stats.txt|grep Uptime|head -1 |awk '{print $2}'`
#	qps=`expr $Questions / $uptime`
	echo $Questions



}




function get_tps(){
	
	Handler_commit=`cat /tmp/mysql_stats.txt|grep Handler_commit|awk '{print $2}'`
	Handler_rollback=`cat /tmp/mysql_stats.txt|grep Handler_rollback|awk '{print $2}'`
#	uptime=`cat /tmp/mysql_stats.txt|grep Uptime|head -1 |awk '{print $2}'`
	tps=`expr $(($Handler_commit + $Handler_rollback))`
	echo $tps



}

if [ $flag = "qps" ];then
        get_qps


elif [ $flag = "tps" ];then
        get_tps
else
   exit 1
fi
