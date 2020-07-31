## ls and du

du 查看文件实际占用磁盘block大小  （block整数倍 磁盘扇区）

ls 查看文件大小

比如

dd if=/dev/zero of=./access.log bs=1M count=0 seek=100000

ls 显示100000M大小，du显示0