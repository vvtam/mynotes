## 用法
### 切割视频
ffmpeg -ss 00:00:00 -i input -vcodec copy -acodec copy -t 00:01:00 output


ffmpeg -i AMFY.ts -c:a aac -strict experimental -ac 2 -b:a 128k -ar 44100 -c:v libx264 -pix_fmt yuv420p -profile:v baseline -level 21 -b:v 4000K -r 12 -g 36 -f hls -hls_time 10 -hls_list_size  0 -s 1280x720 720p.m3u8

ffmpeg -y -i 'WCA2016职业赛S3星际争霸2小组赛ToodmingVSRYEJieShi.mp4' -vcodec h264 -x264-params "nal-hrd=cbr" -acodec aac -b:v 8M -minrate 8M -maxrate 8M -bufsize 1835k -b:a 64K -s 1920x1080 -ar 48000 -r 25 'WCA2016职业赛S3星际争霸2小组赛ToodmingVSRYEJieShi.ts'
