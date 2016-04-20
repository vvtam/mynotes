#ntpd的配置#

```
restrict 127.0.0.1
restrict ::1
restrict 192.168.1.0 mask 255.255.255.0 notrap nomodify

# Hosts on local network are less restricted.
# #restrict 192.168.1.0 mask 255.255.255.0 nomodify notrap
#
# # Use public servers from the pool.ntp.org project.
# # Please consider joining the pool (http://www.pool.ntp.org/join.html).

server time.nist.gov prefer
server 0.asia.pool.ntp.org
server 1.asia.pool.ntp.org
server 2.asia.pool.ntp.org
fudge 127.127.1.0 stratum 10
driftfile /var/lib/ntp/drift
```
