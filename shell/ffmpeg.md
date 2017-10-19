# ffmpeg转码

```
while read LINE;
do ffmpeg -y -i "$LINE.mkv.ts" -vcodec h264 -x264-params "nal-hrd=cbr" -acodec aac -b:v 8M -minrate 8M -maxrate 8M -bufsize 1835k -b:a 64K -s 1920x1080 -ar 48000 -r 25 /data/"$LINE".ts;
done < list
```
```
# for 循环读cat，遇到某行里面有空格的时候会读出来很多行，用while read 读不会
for f in $(cat list); do ffmpeg -y -i "$f" -vcodec h264 -x264-params "nal-hrd=cbr" -acodec aac -b:v 8M -minrate 8M -maxrate 8M -bufsize 1835k -b:a 64K -s 1920x1080 -ar 48000 -r 25 /data/"$f".ts; done
```
