#!/bin/bash

OLD_IFS="$IFS"
IFS=$'\x0A'

touch name_and_duration.csv
#避免Windows下面打开乱码
printf "\xEF\xBB\xBF" > name_and_duration.csv
echo "dir, second" >> name_and_duration.csv

for i in `cat filelist`;do
	#获取时长，秒
	duration=$(ffprobe -show_entries format=duration -v quiet -of csv='p=0' -i "$i")
	#文件名有','的时候会多出一列
	echo "$i, $duration" >> name_and_duration.csv
done

IFS=$OLD_IFS
