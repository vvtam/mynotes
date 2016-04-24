#centos 7 系统参数优化#

把vim加入到环境变量  

`echo alias vi='vim' >> /etc/bashrc`
添加lib目录到共享库  
`echo "/usr/local/lib/" >> /etc/ld.so.conf`
修改记录格式  
`echo 'export HISTTIMEFORMAT="%F %T `whoami` "' >> /etc/profile`
修改记录条数  
`sed -i "s/HISTSIZE=1000/HISTSIZE=999999999/" /etc/profile`
关闭ssh的反解  
`echo 'UseDNS no' >> /etc/ssh/sshd_config`
优化ulimit  
```
echo -e "*\tsoft\tnofile\t65535" >> /etc/security/limits.conf
echo -e "*\thard\tnofile\t65535" >> /etc/security/limits.conf

echo -e "*\tsoft\tnofile\t65535" >> /etc/security/limits.d/20-nproc.conf
echo -e "*\thard\tnofile\t65535" >> /etc/security/limits.d/20-nproc.conf
```
优化内核参数   
```
echo "#-------------insert-------------" >> /etc/sysctl.conf
echo "net.core.netdev_max_backlog = 32768" >> /etc/sysctl.conf
echo "net.core.rmem_default = 8388608" >> /etc/sysctl.conf
echo "net.core.rmem_max = 16777216" >> /etc/sysctl.conf
echo "net.core.somaxconn = 32768" >> /etc/sysctl.conf
echo "net.core.wmem_default = 8388608" >> /etc/sysctl.conf
echo "net.core.wmem_max = 16777216" >> /etc/sysctl.conf
echo "net.ipv4.ip_local_port_range = 5000    65000" >> /etc/sysctl.conf
echo "net.ipv4.tcp_fin_timeout = 30" >> /etc/sysctl.conf
echo "net.ipv4.tcp_keepalive_time = 300" >> /etc/sysctl.conf
echo "net.ipv4.tcp_max_orphans = 3276800" >> /etc/sysctl.conf
echo "net.ipv4.tcp_max_syn_backlog = 65536" >> /etc/sysctl.conf
echo "net.ipv4.tcp_max_tw_buckets = 5000" >> /etc/sysctl.conf
echo "net.ipv4.tcp_mem = 94500000 915000000 927000000" >> /etc/sysctl.conf
echo "net.ipv4.tcp_syn_retries = 2" >> /etc/sysctl.conf
echo "net.ipv4.tcp_synack_retries = 2" >> /etc/sysctl.conf
echo "net.ipv4.tcp_syncookies = 1" >> /etc/sysctl.conf
echo "net.ipv4.tcp_timestamps = 0" >> /etc/sysctl.conf
echo "net.ipv4.tcp_tw_recycle = 1" >> /etc/sysctl.conf
echo "net.ipv4.tcp_tw_reuse = 1" >> /etc/sysctl.conf

/sbin/sysctl -p
```
关闭系统不需要的服务  
```
systemctl disable auditd.service
systemctl disable irqbalance.service
systemctl disable lvm2-monitor.service
systemctl disable postfix.service
```
