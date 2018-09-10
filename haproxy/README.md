# haproxy

## 安装haproxy
make TARGET=linux2628 PREFIX=/path  
make install PREFIX=/path  

## haproxy相关配置

### nginx获取真实ip配置
```
# haproxy 配置
option          forwardfor
# nginx 配置，推荐配置在server 段
set_real_ip_from  172.17.56.0/26;  #haproxy 所在的ip段
real_ip_header    X-Forwarded-For;
real_ip_recursive on;
```
