## 基本用法

*/1 * * * * root /usr/bin/flock -xn /tmp/npss3.tmp /usr/local/bin/webbench -c 200 -t 60 "http://192.168.95.76:51002/nl.ts?id=RANDOM&ndi=device_id001&nn_from_epg_server=1"
*/1 * * * * root cd /root/nn_npss.3.8.30/201002.run/log/ && cat log_info* > temp && grep monitor ./temp >> ./xxx.txt
#nmon per one hour
0 * * * * root cd /root/ && /usr/bin/nmon -f -t -s30 -c120

special time specification nickname
@reboot    :    Run once after reboot.
@yearly    :    Run once a year, ie.  "0 0 1 1 *".
@annually  :    Run once a year, ie.  "0 0 1 1 *".
@monthly   :    Run once a month, ie. "0 0 1 * *".
@weekly    :    Run once a week, ie.  "0 0 * * 0".
@daily     :    Run once a day, ie.   "0 0 * * *".
@hourly    :    Run once an hour, ie. "0 * * * *".

## cron.daily

/etc/cron.daily/ 

/etc/anacrontab 定义时间

```
# /etc/anacrontab: configuration file for anacron

# See anacron(8) and anacrontab(5) for details.

SHELL=/bin/sh
PATH=/sbin:/bin:/usr/sbin:/usr/bin
MAILTO=root
# the maximal random delay added to the base delay of the jobs
RANDOM_DELAY=45
# the jobs will be started during the following hours only
START_HOURS_RANGE=3-22

#period in days   delay in minutes   job-identifier   command
1	5	cron.daily		nice run-parts /etc/cron.daily
7	25	cron.weekly		nice run-parts /etc/cron.weekly
@monthly 45	cron.monthly		nice run-parts /etc/cron.monthly

```



tmpwatch 删tmp 文件