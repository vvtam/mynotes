#!/bin/sh 
export PATH=$PATH:/usr/bin:/bin:/usr/local/bin:/sbin:/usr/sbin:/usr/local/sbin:/usr/local/mysql/bin/
MYSQL_SOCK="127.0.0.1" 
MYSQL_USER="xxx"
MYSQL_PWD="xxx"
ARGS=1 
if [ $# -ne "$ARGS" ];then 
echo "Please input one arguement:" 
fi 
case $1 in
    Uptime) 
        result=`/usr/local/mysql/bin/mysqladmin -u${MYSQL_USER} -p${MYSQL_PWD} -h $MYSQL_SOCK status 2>/dev/null|cut -f2 -d":"|cut -f1 -d"T"` 
         echo $result 
            ;; 
        Com_update) 
            result=`/usr/local/mysql/bin/mysqladmin -u${MYSQL_USER} -p${MYSQL_PWD} -h $MYSQL_SOCK extended-status 2>/dev/null |grep -w "Com_update"|cut -d"|" -f3` 
           echo $result 
;;
        Slow_queries) 
        result=`/usr/local/mysql/bin/mysqladmin -u${MYSQL_USER} -p${MYSQL_PWD} -h $MYSQL_SOCK status 2>/dev/null|cut -f5 -d":"|cut -f1 -d"O"` 
                echo $result 
                ;; 
    Com_select) 
        result=`/usr/local/mysql/bin/mysqladmin -u${MYSQL_USER} -p${MYSQL_PWD} -h $MYSQL_SOCK extended-status 2>/dev/null |grep -w "Com_select"|cut -d"|" -f3`
                echo $result 
                ;; 
    Com_rollback) 
        result=`/usr/local/mysql/bin/mysqladmin -u${MYSQL_USER} -p${MYSQL_PWD} -h $MYSQL_SOCK extended-status 2>/dev/null|grep -w "Com_rollback"|cut -d"|" -f3` 
                echo $result 
                ;;
    Threads_connected)
        result=`/usr/local/mysql/bin/mysqladmin -u${MYSQL_USER} -p${MYSQL_PWD} -h $MYSQL_SOCK extended-status 2>/dev/null|grep -w "Threads_connected"|cut -d"|" -f3`
                echo $result 
                ;;
    Threads_running)
        result=`/usr/local/mysql/bin/mysqladmin -u${MYSQL_USER} -p${MYSQL_PWD} -h $MYSQL_SOCK extended-status 2>/dev/null|grep -w "Threads_running"|cut -d"|" -f3`
                echo $result 
                ;;
    max_connections)
        result=`/usr/local/mysql/bin/mysql -u${MYSQL_USER} -p${MYSQL_PWD} -h $MYSQL_SOCK -e"show global variables"  2>/dev/null|grep -w "max_connections"|awk '{print $2}'`
                echo $result 
                ;; 
    mysql_slave)
	flg=`/usr/local/mysql/bin/mysql -u${MYSQL_USER} -p${MYSQL_PWD} -h $MYSQL_SOCK -e "show global variables like '%read_only%'"|grep ON|wc -l`
	if [ $flg -eq 1 ];then
		
       		num=`/usr/local/mysql/bin/mysql -u${MYSQL_USER} -p${MYSQL_PWD} -h $MYSQL_SOCK -e"show slave status \G"  2>/dev/null|grep Running|grep Yes|wc -l`
		if [ $num -eq 2 ];then
			result=`/usr/local/mysql/bin/mysql -u${MYSQL_USER} -p${MYSQL_PWD} -h $MYSQL_SOCK -e"show slave status \G"  2>/dev/null|grep Seconds_Behind_Master|cut -d: -f2 `
                	echo $result
		else
			echo 9999
		fi
	else
		echo 1
        fi
		;;
    Questions) 
        result=`/usr/local/mysql/bin/mysqladmin -u${MYSQL_USER} -p${MYSQL_PWD} -h $MYSQL_SOCK status 2>/dev/null|cut -f4 -d":"|cut -f1 -d"S"` 
                echo $result 
                ;; 
    Com_insert) 
        result=`/usr/local/mysql/bin/mysqladmin -u${MYSQL_USER} -p${MYSQL_PWD} -h $MYSQL_SOCK extended-status 2>/dev/null|grep -w "Com_insert"|cut -d"|" -f3` 
                echo $result
                ;; 
    Com_delete)
        result=`/usr/local/mysql/bin/mysqladmin -u${MYSQL_USER} -p${MYSQL_PWD} -h $MYSQL_SOCK extended-status 2>/dev/null|grep -w "Com_delete"|cut -d"|" -f3`
                echo $result                 
		;; 
    Com_commit) 
        result=`/usr/local/mysql/bin/mysqladmin -u${MYSQL_USER} -p${MYSQL_PWD} -h $MYSQL_SOCK extended-status 2>/dev/null|grep -w "Com_commit"|cut -d"|" -f3`
 echo $result
                ;; 
    Bytes_sent) 
        result=`/usr/local/mysql/bin/mysqladmin -u${MYSQL_USER} -p${MYSQL_PWD} -h $MYSQL_SOCK extended-status 2>/dev/null|grep -w "Bytes_sent" |cut -d"|" -f3`
                echo $result
               ;;
    Bytes_received) 
        result=`/usr/local/mysql/bin/mysqladmin -u${MYSQL_USER} -p${MYSQL_PWD} -h $MYSQL_SOCK extended-status 2>/dev/null|grep -w "Bytes_received" |cut -d"|" -f3`
                echo $result 
                ;; 
    Com_begin) 
        result=`/usr/local/mysql/bin/mysqladmin -u${MYSQL_USER} -p${MYSQL_PWD} -h $MYSQL_SOCK extended-status 2>/dev/null|grep -w "Com_begin"|cut -d"|" -f3`
                echo $result
                ;;
        *)
        echo "Usage:$0
(Uptime|Com_update|Slow_queries|Com_select|Com_rollback|Questions)" 
        ;; 
esac 
