#!/bin/bash

##########################################
# description:  MySQL backup shell script#
# author:       tam                      #
##########################################

USER="user"
PASSWORD="passwd"
DATABASE="database"
DBHOST="1.2.3.4"
MAIL="xx@xx.com"
BACKUP_DIR=/data/mysql_backup/    #备份文件存储路径
LOGFILE=/data/mysql_backup/mysql_backup.log    #日志文件路径
 
DATE=`date +%Y%m%d-%H%M`    #用日期格式作为文件名
DUMPFILE=$DATABASE-$DATE.sql
ARCHIVE=$DATABASE-$DATE.sql.tar.gz
OPTIONS="-h$DBHOST -u$USER -p$PASSWORD $DATABASE"
# OPTIONS="-h$DBHOST -u$USER -p$PASSWORD --set-gtid-purged=OFF $DATABASE"
 
#备份目录是否存在，否则创建该目录
if [ ! -d $BACKUP_DIR ]
then
	mkdir -p "$BACKUP_DIR"
fi

#写日志
echo "    " >> $LOGFILE
echo "--------------------" >> $LOGFILE
echo "BACKUP DATE:" $(date +"%y-%m-%d %H:%M:%S") >> $LOGFILE
echo "-------------------" >> $LOGFILE

#切换至备份目录
cd $BACKUP_DIR
/usr/local/mysql/bin/mysqldump $OPTIONS > $DUMPFILE
#判断数据库备份是否成功
if [[ $? == 0 ]]
then
    tar czvf $ARCHIVE $DUMPFILE >> $LOGFILE 2>&1
    echo "[$ARCHIVE] Backup Successful!" >> $LOGFILE
    rm -f $DUMPFILE    #删除原始备份文件,只需保留备份压缩包
    #把压缩包文件备份到其他机器上。
    scp $BACKUP_DIR$ARCHIVE root@172.17.3.35:/home/mysql_backup/ >> $LOGFILE  2>&1
else
    echo "Database Backup Fail!" >> $LOGFILE
    #备份失败后向管理者发送邮件提醒
    #mail -s "database:$DATABASE Backup Fail!" $MAIL
fi
echo "Backup Process Done"
#删除7天以上的备份文件
find $BACKUP_DIR  -type f -mtime +7 -name "*.tar.gz" -exec rm -f {} \;
