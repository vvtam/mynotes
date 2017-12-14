#!/bin/bash

OLD_IFS="$IFS"
IFS=$'\x0A'

WORKDIR=/mount/sdd/copy
VIDEODIR=primary
cd $WORKDIR

function read_dir(){
    for file in `ls $1`
    do
        if [ -d $1"/"$file ]
        then
            read_dir $1"/"$file
        else
            echo $1"/"$file   #print the dir and the filename
            echo $1  #print the dir
            FILENAME=$(basename $file .mp4)
	    FILENAME=$(echo "$FILENAME"|sed 's/ /_/g') #替换空格
            echo $FILENAME #print the filename without the suffix
	    mkdir -p $WORKDIR/hls/$1/$FILENAME
	    /usr/local/ffmpeg/bin/ffmpeg -i $1"/"$file -c:a copy -c:v copy -f hls -hls_time 10 -hls_list_size 0 hls/$1/$FILENAME/playlist.m3u8
        fi
    done
}
read_dir $VIDEODIR

IFS=$OLD_IFS
