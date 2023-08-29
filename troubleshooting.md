

## Linux

### 收到SYN包，没有回复

https://access.redhat.com/solutions/18035

- Red Hat Enterprise Linux
- Network traffic using Transmission Control Protocol (TCP)
- Network with load balancer (such as BigIP F5) or a router which performs Network Address Translation (NAT)

客户端发送了SYN包，服务器收到后没有回复，客户端会重发，直到`net.ipv4.tcp_syn_retries`

SYN packets are usually retransmitted at times 1s, 3s, 7s, 15, 31s.

For servers with both the `net.ipv4.tcp_tw_recycle` and the `net.ipv4.tcp_timestamps` enabled, the probability of this problem is very high when the server has NAT client access. From the client side, the symptom of this problem is that the new connection is unstable. Sometimes it can be connected and sometimes it cannot.

The length of the accept queue is limited. The length depends on the min `[backlog, net.core.somaxconn]`, which is the smaller one of the two parameters.



TCP Timestamps should not be used with NAT.

Disable TCP Timestamps and persist the change across reboots:

```
echo "net.ipv4.tcp_timestamps = 0" >> /etc/sysctl.conf
sysctl -p
```

Restart the listening application to ensure all previous TCP streams with TCP Timestamps have been ended.

BigIP F5 (Or other firewalls with similar tcp timestamp option): setting "tcp timestamp mode", has options of `preserve`, `rewrite`, or `strip.` The `preserve` value is most likely to encounter the problems described in this article, when used with NAT. Blocking the original time stamp from the SYN originator with `strip` or `rewrite` is believed to avoid this issue. *Red Hat defers to F5 documentation and support for specifics of any configuration on the firewall and only provides this high level information as a courtesy to our customers*

```undefined
$ tcpdump -ttt -n -i eth2 icmp
00:00.000000 IP x.x.x.a > x.x.x.b: ICMP echo request, id 19283
00:01.296841 IP x.x.x.b > x.x.x.a: ICMP echo reply, id 19283
```

使用systemtap 工具

TCP监听状态有两个单独的队列，SYN Queue，Accept Queue

The SYN Queue stores inbound SYN packets[[1\]](https://blog.cloudflare.com/syn-packet-handling-in-the-wild/#fn1) (specifically: [`struct inet_request_sock`](https://elixir.free-electrons.com/linux/v4.14.12/source/include/net/inet_sock.h#L73)). It's responsible for sending out SYN+ACK packets and retrying them on timeout. On Linux the number of retries is configured with:

```
$ sysctl net.ipv4.tcp_synack_retries
net.ipv4.tcp_synack_retries = 5
```

The [docs describe this toggle](https://www.kernel.org/doc/Documentation/networking/ip-sysctl.txt):

```
tcp_synack_retries - INTEGER

	Number of times SYNACKs for a passive TCP connection attempt
	will be retransmitted. Should not be higher than 255. Default
	value is 5, which corresponds to 31 seconds till the last
	retransmission with the current initial RTO of 1second. With
	this the final timeout for a passive TCP connection will
	happen after 63 seconds.
```

After transmitting the SYN+ACK, the SYN Queue waits for an ACK packet from the client - the last packet in the three-way-handshake. All received ACK packets must first be matched against the fully established connection table, and only then against data in the relevant SYN Queue. On SYN Queue match, the kernel removes the item from the SYN Queue, happily creates a fully fledged connection (specifically: [`struct inet_sock`](https://elixir.free-electrons.com/linux/v4.14.12/source/include/net/inet_sock.h#L183)), and adds it to the Accept Queue.

### netstat显示源ip和ss显示不一样

netstat某个版本显示的源ip，和ss，tcpdump抓包显示的源ip不一样，特别是ipv4的最后一位

### 系统负载高，但是cpu，内存，磁盘，网络占用正常

vmstat 1 100 -Sm 发现cs切换特别高 

pidstat -w 2 发现cs切换频繁的进程是nfs相关，发现nfs服务端服务异常

### 单用户启动

```
修改Linux 16开头的行，将ro改为rw init=/sysroot/bin/sh
# 启动
Control+x
chroot /sysroot

# reset password，其它维护操作
passwd root

# selinux
touch /.autorelabel

#chroot
exit

#重启系统
reboot
```

### 救援模式启动，root账号需要启用

```
# linux16 开头行末尾加上systemd.unit=emergency.target 启动
linux16 /vmlinuz-3.10.0-327.36.1.el7.x86_64 root=/dev/mapper/rhel_unus\
ed-root ro console=tty0 crashkernel=128M rd.lvm.lv=rhel_unused/root rd.lvm.lv=\
rhel_unused/swap console=ttyS0,115200 LANG=en_US.UTF-8 systemd.unit=emergency.target
```

### 设置limit 的坑

默认软限制

```
*          soft    nproc     4096
root       soft    nproc     unlimited
```

sysctl 里面的限制，

```
fs.nr_open = 1048576
fs.file-max = 366671
fs.file-nr = 1504       0       366671
```

ulimit 设置open files 不能操作这个数字

```
# ulimit -n 1048577
-bash: ulimit: open files: cannot modify limit: Operation not permitted
```

设置硬限制超过  `fs.nr_open = 1048576`         
`*          hard    nofile     1048588` 后，登录会失败
