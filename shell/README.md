## su

su - 启动一个字登录shell

su 与当前用户匹配的非登录子shell

-, -l, --login
              Start the shell as a login shell with an environment similar to a real login

## shell脚本

利用inotify监控文件并且执行命令
```
#!/bin/bash

# install inotify-tools

# get the current path
#CURPATH=`pwd`

# or set your path
CURPATH=/data/wwwroot/cig/app/public/storage/data/adi

inotifywait -mr --timefmt '%d/%m/%y %H:%M' --format '%T %w %f' \
-e close_write $CURPATH | while read date time dir file; do
        FILECHANGE=${dir}${file}
        #convert absolute path to relative
        FILECHANGEREL=`echo "$FILECHANGE" | sed 's_'$CURPATH'/__'`

        /usr/local/php/bin/php /data/wwwroot/cig/app/crontab/adi.php $FILECHANGEREL

        #echo "$FILECHANGEREL" >> /tmp/list
        #echo "$FILECHANGE" >> /tmp/list
done
```

```

```
