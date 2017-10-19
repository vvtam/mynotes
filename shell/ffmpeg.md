# ffmpeg转码

```
#如果文本list每行中没有空格，则line在list中按换行符分隔符循环取值
#如果list中包括空格或制表符，则不是换行读取，而是按空格分隔符或制表符或换行符循环取值
#可以通过把IFS设置为换行符来达到逐行读取的功能
#IFS的默认值为：空白(包括：空格，制表符，换行符)

#!/bin/bash

OLD_IFS="$IFS"
IFS=$'\x0A'

for f in $(cat list); do ffmpeg -y -i "$f" -vcodec h264 -x264-params "nal-hrd=cbr" -acodec aac -b:v 8M -minrate 8M -maxrate 8M -bufsize 1835k -b:a 64K -s 1920x1080 -ar 48000 -r 25 /data/"$f".ts; done

IFS="$OLD_IFS"
```
