#!/bin/bash

#########################################
#author:tam                            ##
#description:                          ##
#date:2016/06/01 13:35                 ##
#########################################

SOU_DIR=/Users/vivitam/Downloads/doc_sample
DES_DIR=/Users/vivitam/Downloads/doc_sample_pp
#dir size use mb,only number
DIR_MAX_SIZE=300000

function cpfile()
{
    mkdir -p $DES_DIR/300_$1;
    for f in $(cat filelist); do
        mv "$f" $DES_DIR/300_$1;
        DIR_SIZE=$(du -sm $DES_DIR/300_$1 | awk '{print $1}');
        if [ "$DIR_SIZE" -le 300000 ] && [ "$DIR_SIZE" -ge 290000 ];then
           break
        fi
    done
}

for ((i=1;i<=15;i++));do
    cd $SOU_DIR
    find ./ -type f -name "*.ts" > filelist
    cpfile $i;
done
