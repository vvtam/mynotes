#!/bin/bash

#########################################
#author:tam                            ##
#description:                          ##
#date:2016/06/01 13:35                 ##
#########################################

SOU_DIR="/Users/vivitam/Documents/test space"
DES_DIR="/Users/vivitam/Documents/test space/video"
#dir size use mb,only number
DIR_MAX_SIZE=300000

function cpfile()
{
    if [ ! -d "$DES_DIR"/300_$1 ];then
        mkdir -p "$DES_DIR"/300_$1
    fi
    DIR_SIZE=$(du -sm "$DES_DIR"/300_$1 | awk '{print $1}')
    while [ "$DIR_SIZE" -le 28 ];do
        read LINE
        for f in "$LINE";do
            cp "$f" "$DES_DIR"/300_$1/
            DIR_SIZE_NEW=$(du -sm "$DES_DIR"/300_$1 | awk '{print $1}')
            if [ "$DIR_SIZE_NEW" -le 300 ] && [ "$DIR_SIZE" -ge 250 ];then
                break 
            fi
        done
    done < filelist
}

for ((i=1;i<=15;i++));do
    cd "$SOU_DIR"
    find . -path "./video" -prune -o -type f -name "*.pdf" -print > filelist
    cpfile $i
done
