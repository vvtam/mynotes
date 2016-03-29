#磁盘测试工具#
##fio###
web site   
http://git.kernel.dk/?p=fio.git;a=summary   
http://freecode.com/projects/fio

fio -filename=/dev/sda -direct=1 -iodepth 1 -thread -rw=randrw -rwmixread=70 -ioengine=psync -bs=16k -size=200G -numjobs=4 -runtime=100 -group_reporting -name=mytest -ioscheduler=noop

dd bs=1M count=999999999999999 if=/dev/zero of=test oflag=dsync
