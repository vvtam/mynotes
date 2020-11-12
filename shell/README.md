# shell

## 环境变量

```
env
printenv
printenv HOME
echo $HOME
```

bash命令生成一个子shell，环境变量和父shell一样

### 局部环境变量

set

set命令会显示为某个特定进程设置的所有环境变量，包括局部变量、全局变量以及用户定义变量

unset 删除环境变量

export 导入环境变量，子环境不能修改父环境的变量

## 文件权限

SGID，设置sgid后，新建文件都继承目录的组权限 chmod g+s

## 文件系统

主分区，扩展分区 >> 逻辑分区

## 基本脚本

### 命令替换

``

$()

命令替换会创建一个子shell来运行对应的命令

命令行提示符下使用路径./运行命令的话，也会创建出子shell

要是运行命令的时候不加入路径，就不会创建子shell。如果你使用的是内建的shell命令，并不会涉及子shell

### 重定向

```
>, >>, <
```

内联输入重定向（inine input redirection）

```
command << marker
data1
data2
marker

$ cat xx.txt << EOF
> data1
> data2
> EOF
> 是PS2 定义的提示符
```

### 管道Piping

command1 | command2
不要以为由管道串起的两个命令会依次执行。Linux系统实际上会同时运行这两个命令，在
系统内部将它们连接起来。在第一个命令产生输出的同时，输出会被立即送给第二个命令。数据
传输不会用到任何中间文件或缓冲区。

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
