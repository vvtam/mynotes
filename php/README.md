#php#
##问题##
_open_  
version php-7.0.5 centos 7.2  
php-fpm监听的是sock文件，位置为/dev/shm/ (内存)，访问报502，/dev/shm下的sock文件被莫名删除   

