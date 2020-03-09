## 参考 https://www.cnblogs.com/276815076/p/8004039.html
# TCP计数器ListenOverflows大量增加
查看方法：
  cat /proc/net/netstat | awk '/TcpExt/ { print $21,$22 }'
原因：
  系统调用listen函数（int listen(int sockfd, int backlog)；）的队列长度 \
  由min（backlog ，内核参数 net.core.somaxconn ） 决定 \
  对应socket的listen 队列已满的情况下，在新增一个连接时的情况，ListenOverflows计数器加 1
解决办法：
  调整系统参数 net.core.somaxconn = 65535
  
# HAProxy 耗尽cpu问题
方法：
  mpstat -P ALL 1 查看cpu占用情况
  strace -p pid-number -c 检查进程  
原因：
  HAProxy连接后端会使用connect系统调用，如果后端机器太少，大量的连接会积压在haproxy机器上，导致cpu高
解决办法：
  增加后端机器
# 网卡drop数据包
办法：
  网卡Ring buffer
  ethtool -g eth0
  ethtool -G eth0 rx 4096;ethtool -G eth0 tx 4096
  网卡队缓存队列
  net.core.netdev_max_backlog = 2000000
  
# 其它
  每个连接会消耗内存资源 增加机器内存
  增加打开文件数
  
