#!/usr/bin/env bash

MONITOR_DIR=/data/wwwroot/cms
MONITOR_IGNORE_DIRS=/data/wwwroot/cms/app/public/storage/logs/ # example: (data/cache/|data/locks/|data/index/|data/tmp/)'
LOG_LOCAL_PATH=/data/wwwroot/rsync-log/
#BACKUP_MACHINE_IP=epg01
#BACKUP_MACHINE_USER=someone
BACKUP_MACHINE_PATH=/data/wwwroot/cms

function LOG()
{
    LOG_FILE=$LOG_LOCAL_PATH`date +'%Y-%m-%d'`.log
    echo "$@">>$LOG_FILE
}

# start the real-time backup service
function start() {

    LOG "==========================================="
    LOG "rsync Start at:" `date +%H:%M:%S`
    LOG "==========================================="

    cd $MONITOR_DIR || { LOG 'MONITOR_DIR ERROR' && exit 1; }
    inotifywait -mrq --excludei='$MONITOR_IGNORE_DIRS' --format '%e %w%f %T' --timefmt='%Y-%m-%d/%H:%M:%S' -e modify,create,delete,attrib,close_write,move .  | \
    while read INO_EVENT INO_FILE INO_TIME
    do
           echo $INO_TIME" "$INO_FILE" "$INO_EVENT

           if [[ $INO_EVENT =~ 'CREATE' ]] || [[ $INO_EVENT =~ 'MODIFY' ]] ||
              [[ $INO_EVENT =~ 'CLOSE_WRITE' ]] || [[ $INO_EVENT =~ 'MOVED_TO' ]] ||
              [[ $INO_EVENT =~ 'ATTRIB' ]]
           then
                #rsync -avzcR ${INO_FILE} ${BACKUP_MACHINE_USER}@${BACKUP_MACHINE_IP}:${BACKUP_MACHINE_PATH}
                rsync -avlR ${INO_FILE} --exclude-from=rsync_cms_to_epg_exclude.list -e 'ssh -p 54321' cms root@epg01:${BACKUP_MACHINE_PATH}
                rsync -avlR ${INO_FILE} --exclude-from=rsync_cms_to_epg_exclude.list -e 'ssh -p 54321' cms root@epg02:${BACKUP_MACHINE_PATH}
                rsync -avlR ${INO_FILE} --exclude-from=rsync_cms_to_epg_exclude.list -e 'ssh -p 54321' cms root@epg03:${BACKUP_MACHINE_PATH}
           fi

           if [[ $INO_EVENT =~ 'DELETE' ]] || [[ $INO_EVENT =~ 'MOVED_FROM' ]]
           then
                #rsync -avzR --delete $(dirname ${INO_FILE}) ${BACKUP_MACHINE_USER}@${BACKUP_MACHINE_IP}:${BACKUP_MACHINE_PATH}
                rsync -avlR ${INO_FILE} --exclude-from=rsync_cms_to_epg_exclude.list -e 'ssh -p 54321' cms root@epg01:${BACKUP_MACHINE_PATH}
                rsync -avlR ${INO_FILE} --exclude-from=rsync_cms_to_epg_exclude.list -e 'ssh -p 54321' cms root@epg02:${BACKUP_MACHINE_PATH}
                rsync -avlR ${INO_FILE} --exclude-from=rsync_cms_to_epg_exclude.list -e 'ssh -p 54321' cms root@epg03:${BACKUP_MACHINE_PATH}
           fi

           #if [[ $INO_EVENT =~ 'ATTRIB' ]]
           #then
           #            if [ ! -d "$INO_FILE" ]
           #            then
           #                rsync -avzcR $(dirname ${INO_FILE}) ${BACKUP_MACHINE_USER}@${BACKUP_MACHINE_IP}:${BACKUP_MACHINE_PATH}
           #            fi
           #fi
    done

}

# stop the backup service
function stop() {
    LOG "==================================================="
    LOG "Backup stop at:" `date +%H:%M:%S`" >_< "
    LOG "==================================================="
    sudo killall $(basename "$0")
}

# backup all data
function oneshot() {
    LOG "==================================================="
    LOG "Backup Oneshot start at:" `date +%H:%M:%S`
    LOG "==================================================="

    cd $MONITOR_DIR || { LOG 'MONITOR_DIR ERROR' && exit 1; }
    rsync -avzcR ./ ${BACKUP_MACHINE_USER}@${BACKUP_MACHINE_IP}:${BACKUP_MACHINE_PATH}

    LOG "======================================================"
    LOG "Backup Oneshot Finished at:" `date +%H:%M:%S`
    LOG "======================================================"
}

# main
if [ ! $# -eq 1 ]; then
    echo "Usage: $0 [start|stop|oneshot]"
    exit 1;
fi

case $1 in
  start|stop|oneshot) "$1" ;;
  *) echo "Unkonwn param: $1"
     echo "Usage: $0 [start|stop|oneshot]"
esac
