## 禁用apt ipv6
```
sudo touch /etc/apt/apt.conf.d/99force-ipv4
sudo echo "Acquire::ForceIPv4 true;" > /etc/apt/apt.conf.d/99force-ipv4
```
