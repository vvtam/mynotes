#!/usr/bin/env bash

OLD_IFS="$IFS"
IFS=$'\x0A'

WORKDIR=/mount/nfs/xiazai
cd $WORKDIR

VIDEODIR=huiben

function read_dir(){
    for file in `ls $1`
    do
        if [ -d $1"/"$file ]
        then
            read_dir $1"/"$file
        else
            echo $1"/"$file   #print the dir and the filename
            echo $1  #print the dir
	    #参数替换，提取文件名，不含文件名扩展
            FILENAME=${file%.*}
	    FILENAME=$(echo "$FILENAME"|sed 's/ /_/g') #替换空格
            echo $FILENAME #print the filename without the suffix
	    mkdir -p $WORKDIR/transcode/$1
	    /usr/local/ffmpeg/bin/ffmpeg -i $1"/"$file -vcodec h264 -profile:v high -level:v 3.2 -x264-params "nal-hrd=cbr" -acodec mp2 -b:v 5M -minrate 5M -maxrate 5M -bufsize 2M -b:a 320K -s 1280x720 -ar 48000 -r 30 $WORKDIR/transcode/$1/$FILENAME.ts
	    # /usr/local/ffmpeg/bin/ffmpeg -i $1"/"$file -vcodec h264 -profile:v high -level:v 3.2 -x264-params "nal-hrd=cbr" -acodec mp2 -b:v 5M -minrate 5M -maxrate 5M -bufsize 1835k -b:a 320K -s 1280x720 -ar 48000 -r 30 $WORKDIR/transcode/$1/$FILENAME.ts
        fi
    done
}
read_dir $VIDEODIR

IFS=$OLD_IFS
