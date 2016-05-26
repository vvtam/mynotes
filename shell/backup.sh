#!/bin/bash

###########################################
#description: backup something          ##
#author:      tam                       ##
#date:        2016/05/26                ##
##########################################

BACKUP_DIR=
BACKUP_APP=
BACKUP_DATE=`date +%Y%m%d-%H%M`
KEEP_DAYS=7

RESTORE_DIR=
ARCHIVE_FILE=$BACKUP_APP-$BACKUP_DATE.tar.gz
LOGFILE=

ADMIN_MAIL=

#back to remote server
SERVER_NAME=
SERVER_IP=
SERVER_PORT=54321
SERVER_USER= 
SERVER_DIR=
##########################################

# check the backup and restore dir
if [ ! -d $BACKUP_DIR ]
then
    mkdir -p "$BACKUP_DIR"
fi


if [ ! -d $RESTORE_DIR ]
then
    mkdir -p "$RESTORE_DIR"
fi

#create log
echo "--------------------" >> $LOGFILE
echo "BACKUP DATE:" $BACKUP_DATE >> $LOGFILE

#cd backup dir
cd $BACKUP_DIR
cp -r "$BACKUP_APP" $RESTORE_DIR
if [[ $? == 0 ]]
then
    cd $RESTORE_DIR
    tar czvf $ARCHIVE_FILE $BACKUP_APP >> $LOGFILE 2>&1 
    echo "$ARCHIVE_FILE backup success" >> $LOGFILE 
    rm -rf $BACKUP_APP
    scp -P $SERVER_PORT $ARCHIVE_FIEL $SERVER_USER@$SERVER_IP:$SERVER_DIR >> $LOGFILE 2>&1
else
    echo "backup failed" >> $LOGFILE
    #mail -s "backup failed:$ARCHIVE_FILE" $ADMIN_MAIL 
fi

echo "backup process done" >> $LOGFILE

#delete the file over xx days
find $RESTORE_DIR -type f -mtime +$KEEP_DAYS name "*.tar.gz" -exec rm -f {} \;

