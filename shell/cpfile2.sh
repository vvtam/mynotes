#!/bin/bash

#########################################
#author:tam                            ##
#description:                          ##
#date:2016/06/01 13:35                 ##
#########################################

SOU_DIR="/Volume/Seagate Expansion Drive"
DES_DIR="/Volume/Seagate Expansion Drive/video"
#SOU_DIR="/Users/vivitam/Documents/test space"
#DES_DIR="/Users/vivitam/Documents/test space/video"
#dir size use mb,only number
DIR_MAX_SIZE=300000

function cpfile()
{
    if [ ! -d "$DES_DIR"/300_$1 ];then
        mkdir -p "$DES_DIR"/300_$1
    fi
    DIR_SIZE=$(du -sm "$DES_DIR"/300_$1 | awk '{print $1}')
    while [ "$DIR_SIZE" -le 280000 ];do
        read LINE
        for f in "$LINE";do
            if [ "$?" -eq 1 ];then
                exit 1
            fi
            mv "$f" "$DES_DIR"/300_$1/
            NEW_SIZE=$(du -sm "$DES_DIR"/300_$1 | awk '{print $1}')
            DIR_SIZE="$NEW_SIZE"
            if [ "$NEW_SIZE" -le 300000 ] && [ "$NEW_SIZE" -ge 280000 ];then
                break 
            fi
        done
    done < filelist
}

for ((i=1;i<=50;i++));do
    cd "$SOU_DIR"
    #the find dir must use relative dir,and can't include '/',like './',otherwise the exclude dir will not work well
    find . -path "./video" -prune -o -type f -name "*.ts" -print > filelist
    cpfile $i
done
