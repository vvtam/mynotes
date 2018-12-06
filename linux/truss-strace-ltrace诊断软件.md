## strace 追踪php运行慢的问题
strace -t -f -o /root/strace.txt /usr/local/php/bin/php -v

```
33741 23:38:36 poll([{fd=3, events=POLLIN}], 1, 5000) = 0 (Timeout)
33741 23:38:41 poll([{fd=3, events=POLLOUT}], 1, 0) = 1 ([{fd=3, revents=POLLOUT}])
33741 23:38:41 sendmmsg(3, {{{msg_name(0)=NULL, msg_iov(1)=[{"H\240\1\0\0\1\0\0\0\0\0\0\5epg01\0\0\1\0\1", 23}], msg_controllen=0, msg_flags=MSG_OOB|MSG_DONTWAIT|MSG_EOR|MSG_FIN|0x80000}, 23}, {{msg_name(0)=NULL, msg_iov(1)=[{"L\306\1\0\0\1\0\0\0\0\0\0\5epg01\0\0\34\0\1", 23}], msg_controllen=0, msg_flags=0}, 23}}, 2, MSG_NOSIGNAL) = 2
33741 23:38:41 poll([{fd=3, events=POLLIN}], 1, 5000) = 0 (Timeout)
33741 23:38:46 close(3)                 = 0
33741 23:38:46 alarm(0)
```

运行缓慢是因为php解析本机hostname超时，把本机hostname加入到/etc/hosts,问题解决
