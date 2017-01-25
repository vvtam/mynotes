#dnsmasq优化#

[参考这里(https://cokebar.info/archives/1410)](https://cokebar.info/archives/1410)

修改/etc/dnsmasq.conf，添加自定义目录 conf-dir=/etc/dnsmasq.d

加入大陆的域名列表，使用国内的dns解析

[比如https://github.com/felixonmars/dnsmasq-china-list](https://github.com/felixonmars/dnsmasq-china-list)

重启生效

或者其他组合，比如使用黑名单，其它全部使用国内dns

使用白名单，其它全部走国外dns或者结合chinadns+dns-forward
