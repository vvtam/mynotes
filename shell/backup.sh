#!/bin/bash

###########################################
#description: backup something          ##
#author:      tam                       ##
#date:        2016/05/26                ##
##########################################

APP_DIR=/home/data/wwwroot
BACKUP_APP=app
BACKUP_DATE=`date +%Y%m%d-%H%M`
KEEP_DAYS=1

BACKUP_DIR=/data/app_backup
ARCHIVE_FILE=$BACKUP_APP-$BACKUP_DATE.tar.gz
LOGFILE=/data/app_backup/backup.log

ADMIN_MAIL=

#back to remote server
SERVER_NAME=
SERVER_IP=192.168.1.155
SERVER_PORT=22
SERVER_USER=root
SERVER_DIR=/home/data/app_backup
##########################################

# check the backup
if [ ! -d $BACKUP_DIR ]
then
    mkdir -p "$BACKUP_DIR"
fi

#create log
echo "--------------------" >> $LOGFILE
echo "BACKUP DATE:" $BACKUP_DATE >> $LOGFILE

#cd backup dir
cd $APP_DIR
tar czvf $BACKUP_DIR/$ARCHIVE_FILE $BACKUP_APP >> $LOGFILE 2>&1 
echo "$ARCHIVE_FILE backup success" >> $LOGFILE
cd $BACKUP_DIR
scp -P $SERVER_PORT $ARCHIVE_FILE $SERVER_USER@$SERVER_IP:$SERVER_DIR >> $LOGFILE 2>&1
#scp -P $SERVER_PORT $ARCHIVE_FILE $SERVER_USER@$SERVER_NAME:$SERVER_DIR >> $LOGFILE 2>&1

echo "backup process done" >> $LOGFILE

#delete the file over xx days
find $BACKUP_DIR -type f -mtime +$KEEP_DAYS -name "*.tar.gz" -exec rm -f {} \;
