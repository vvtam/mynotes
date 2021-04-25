tcpdump 命令使用简介
简单介绍
tcpdump 是一款强大的网络抓包工具，运行在 linux 平台上。熟悉 tcpdump 的使用能够帮助你分析、调试网络数据。

要想使用很好地掌握 tcpdump， 必须对网络报文（TCP/IP 协议）有一定的了解。不过对于简单的使用来说，只要有网络基础概念就行了。

tcpdump 是一个很复杂的命令，想了解它的方方面面非常不易，也不值得推荐，能够使用它解决日常工作中的问题才是关键。



选项
tcpdump 的选项也很多，要想知道所有选项的话，请参考 man tcpdump，下面只记录 tcpdump 最常用的选项。

需要注意的是，tcpdump 默认只会截取前 96 字节的内容，要想截取所有的报文内容，可以使用 -s number， number 就是你要截取的报文字节数，如果是 0 的话，表示截取报文全部内容。

-n 表示不要解析域名，直接显示 ip。
-nn 不要解析域名和端口
-X 同时用 hex 和 ascii 显示报文的内容。
-XX 同 -X，但同时显示以太网头部。
-S 显示绝对的序列号（sequence number），而不是相对编号。
-i any 监听所有的网卡
-v, -vv, -vvv：显示更多的详细信息
-c number: 截取 number 个报文，然后结束
-A： 只使用 ascii 打印报文的全部数据，不要和 -X 一起使用。截取 http 请求的时候可以用 sudo tcpdump -nSA port 80！
简单使用
1. tcpdump -nS
监听所有端口，直接显示 ip 地址。

2. tcpdump -nnvvS
显示更详细的数据报文，包括 tos, ttl, checksum 等。

3. tcpdump -nnvvXS
显示数据报的全部数据信息，用 hex 和 ascii 两列对比输出。

下面是抓取 ping 命令的请求和返回的两个报文，可以看到全部的数据。

➜  ~  sudo tcpdump -nnvXSs 0 -c2 icmp
tcpdump: data link type PKTAP
tcpdump: listening on pktap, link-type PKTAP (Packet Tap), capture size 65535 bytes

22:58:16.781856 IP (tos 0x0, ttl 64, id 61452, offset 0, flags [none], proto ICMP (1), length 84)
    192.168.1.106 > 192.168.1.1: ICMP echo request, id 65302, seq 0, length 64
    0x0000:  0c72 2c28 b9ac 80e6 5019 4c38 0800 4500  .r,(....P.L8..E.
    0x0010:  0054 f00c 0000 4001 06e1 c0a8 016a c0a8  .T....@......j..
    0x0020:  0101 0800 72c9 ff16 0000 5500 5808 000b  ....r.....U.X...
    0x0030:  ee08 0809 0a0b 0c0d 0e0f 1011 1213 1415  ................
    0x0040:  1617 1819 1a1b 1c1d 1e1f 2021 2223 2425  ...........!"#$%
    0x0050:  2627 2829 2a2b 2c2d 2e2f 3031 3233 3435  &'()*+,-./012345
    0x0060:  3637                                     67
22:58:17.674304 IP (tos 0x0, ttl 64, id 13972, offset 0, flags [none], proto ICMP (1), length 84)
    192.168.1.1 > 192.168.1.106: ICMP echo reply, id 65302, seq 0, length 64
    0x0000:  80e6 5019 4c38 0c72 2c28 b9ac 0800 4500  ..P.L8.r,(....E.
    0x0010:  0054 3694 0000 4001 c059 c0a8 0101 c0a8  .T6...@..Y......
    0x0020:  016a 0000 7ac9 ff16 0000 5500 5808 000b  .j..z.....U.X...
    0x0030:  ee08 0809 0a0b 0c0d 0e0f 1011 1213 1415  ................
    0x0040:  1617 1819 1a1b 1c1d 1e1f 2021 2223 2425  ...........!"#$%
    0x0050:  2627 2829 2a2b 2c2d 2e2f 3031 3233 3435  &'()*+,-./012345
    0x0060:  3637                                     67

2 packets captured
5875 packets received by filter
0 packets dropped by kernel
过滤器
机器上的网络报文数量异常的多，很多时候我们只关系和具体问题有关的数据报（比如访问某个网站的数据，或者 icmp 超时的报文等等），而这些数据只占到很小的一部分。把所有的数据截取下来，从里面找到想要的信息无疑是一件很费时费力的工作。而 tcpdump 提供了灵活的语法可以精确地截取关心的数据报，简化分析的工作量。这些选择数据包的语句就是过滤器（filter）！

过滤器也可以简单地分为三类：type, dir 和 proto。

Type 让你区分报文的类型，主要由 host（主机）, net（网络） 和 port（端口） 组成。src 和 dst 也可以用来过滤报文的源地址和目的地址。

host: 过滤某个主机的数据报文
tcpdump host 1.2.3.4
src, dst: 过滤源地址和目的地址
tcpdump src 2.3.4.5
tcpdump dst 3.4.5.6
net: 过滤某个网段的数据，CIDR 模式
tcpdump net 1.2.3.0/24
proto: 过滤某个协议的数据，支持 tcp, udp 和 icmp。使用的时候可以省略 proto 关键字。
tcpdump icmp
port: 过滤通过某个端口的数据报
tcpdump port 3389
src/dst, port, protocol: 结合三者
tcpdump src port 1025 and tcp
tcpdump udp and src port 53
此外还有指定端口和数据报文范围的过滤器：

port 范围
tcpdump portrange 21-23
数据报大小，单位是字节
tcpdump less 32
tcpdump greater 128
tcpdump > 32
tcpdump <= 128
过于过滤器的更多详细信息，请访问 tcpdump 官方 map page 的 PCAP-FILTER 部分。

输出到文件
使用 tcpdump 截取数据报文的时候，默认会打印到屏幕的默认输出，你会看到按照顺序和格式，很多的数据一行行快速闪过，根本来不及看清楚所有的内容。不过，tcpdump 提供了把截取的数据保存到文件的功能，以便后面使用其他图形工具（比如 wireshark，Snort）来分析。

-w 选项用来把数据报文输出到文件，比如下面的命令就是把所有 80 端口的数据导入到文件

# sudo tcpdump -w capture_file.pcap port 80
-r 可以读取文件里的数据报文，显示到屏幕上。

# tcpdump -nXr capture_file.pcap host web30
NOTE：保存到文件的数据不是屏幕上看到的文件信息，而是包含了额外信息的固定格式 pcap，需要特殊的软件来查看，使用 vim 或者 cat 命令会出现乱码。

强大的过滤器
过滤的真正强大之处在于你可以随意组合它们，而连接它们的逻辑就是常用的 与/AND/&& 、 或/OR/|| 和 非/not/!。

源地址是 10.5.2.3，目的端口是 3389 的数据报
tcpdump -nnvS src 10.5.2.3 and dst port 3389
从 192.168 网段到 10 或者 172.16 网段的数据报
tcpdump -nvX src net 192.168.0.0/16 and dat net 10.0.0.0/8 or 172.16.0.0/16
从 Mars 或者 Pluto 发出的数据报，并且目的端口不是 22
tcpdump -vv src mars or pluto and not dat port 22
从上面的例子就可以看出，你可以随意地组合之前的过滤器来截取自己期望的数据报，最重要的就是知道自己要精确匹配的数据室怎样的！

对于比较复杂的过滤器表达式，为了逻辑的清晰，可以使用括号。不过默认情况下，tcpdump 把 () 当做特殊的字符，所以必须使用单引号 ' 来消除歧义：

tcpdump -nvv -c 20 'src 10.0.2.4 and (dat port 3389 or 22)'
理解 tcpdump 的输出
截取数据只是第一步，第二步就是理解这些数据，下面就解释一下 tcpdump 命令输出各部分的意义。

21:27:06.995846 IP (tos 0x0, ttl 64, id 45646, offset 0, flags [DF], proto TCP (6), length 64)
    192.168.1.106.56166 > 124.192.132.54.80: Flags [S], cksum 0xa730 (correct), seq 992042666, win 65535, options [mss 1460,nop,wscale 4,nop,nop,TS val 663433143 ecr 0,sackOK,eol], length 0

21:27:07.030487 IP (tos 0x0, ttl 51, id 0, offset 0, flags [DF], proto TCP (6), length 44)
    124.192.132.54.80 > 192.168.1.106.56166: Flags [S.], cksum 0xedc0 (correct), seq 2147006684, ack 992042667, win 14600, options [mss 1440], length 0

21:27:07.030527 IP (tos 0x0, ttl 64, id 59119, offset 0, flags [DF], proto TCP (6), length 40)
    192.168.1.106.56166 > 124.192.132.54.80: Flags [.], cksum 0x3e72 (correct), ack 2147006685, win 65535, length 0
最基本也是最重要的信息就是数据报的源地址/端口和目的地址/端口，上面的例子第一条数据报中，源地址 ip 是 192.168.1.106，源端口是 56166，目的地址是 124.192.132.54，目的端口是 80。 > 符号代表数据的方向。

此外，上面的三条数据还是 tcp 协议的三次握手过程，第一条就是 SYN 报文，这个可以通过 Flags [S] 看出。下面是常见的 TCP 报文的 Flags:

[S]： SYN（开始连接）
[.]: 没有 Flag
[P]: PSH（推送数据）
[F]: FIN （结束连接）
[R]: RST（重置连接）
而第二条数据的 [S.] 表示 SYN-ACK，就是 SYN 报文的应答报文。
