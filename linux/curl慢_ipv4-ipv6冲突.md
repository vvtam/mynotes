参考 https://aarvik.dk/disable-ipv6/
```
Introduction
If your Linux machine is slow resolving DNS via cURL, wget or a similar URL transfer util, it may be because of conflicting ipv4/ipv6 resolving.

You can test this by using only ipv4 with cURL:

$ curl -4 aarvik.dk
If this curl request is fast as it should be, but it is not with the -4 flag, this may be your problem aswell. In my case it took up to 6 seconds without ipv4 only flag.

Other methods for deeper debug
You can also test with tcpdump in the background:

$ tcpdump port 53 &
Then run the same line again, just without -4 flag:

$ curl aarvik.dk
Then you will see what is happening between the packets.

With strace you can also see that it will break and timeout on port 53 connection. Use it like this:

$ strace curl aarvik.dk
The fix
I fixed it by appending the following line to my /etc/resolv.conf-file:

options single-request-reopen
This fixes the problem because ipv4 (A) and ipv6 (AAAA) uses the same socket and port for resolving the DNS, and then it may only send back one response, and then cURL or wget, or whatever you use, will wait (probably timeout in first lookup) for the second answer from the DNS resolving. This option makes your machine reopen a new socket if there is a conflict.
```

问题:之前和客户调试接口，返回很慢，怀疑客户的接口慢，抓包发现返回很快，没有看dns部分

于是用strace 发现问题是本地服务器引起的，没有发现是dns的问题

网络搜索发现可能是ipv6的问题以上可以解决

或者禁用ipv6
