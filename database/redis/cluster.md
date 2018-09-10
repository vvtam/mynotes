# redis cluster 配置

## redis安装

正常安装redis，打开cluster配置
```
cluster-enabled yes
cluster-config-file nodes-6379.conf
cluster-node-timeout 5000
cluster-slave-validity-factor 10
cluster-migration-barrier 1
cluster-require-full-coverage yes
cluster-slave-no-failover no
```
启动各个redis节点

## 配置cluster

redis的源码自带一个集群配置脚本，在src目录下 redis-trib.rb

需要ruby 2.4.4 版本及以上，有的系统需要升级ruby
可以用rvm升级管理ruby
```
# http://www.rvm.io
gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
\curl -sSL https://get.rvm.io | bash -s stable
# 按照提示操作
# 升级版本
rvm install ruby-2.4.4
rvm use 2.4.4 default
# 安装redis相关
gem install redis
```
```
/redis-dir/src/redis-trib.rb create --replicas 0 xxx:6379 xxx:6379 xxx:6379
--replicas 0 表示后面的全是master
/redis-dir/src/redis-trib.rb create --replicas 1 xxx:6379 xxx:6379 xxx:6379 xxx:6379 xxx:6379 xxx:6379
--replicas 1 表示master slave 自动分配
```
## cluster操作
```
redis-cli -h ip -p port -c #连接cluster

cluster meet ip port #把某个节点加入到集群
cluster forget nodeID #从集群中移除nodeID对应的节点
```
## 单个节点操作
```
cluster replicate nodeID  #当前节点设置为nodeId节点的从
cluster saveconfig #保存节点配置文件到硬盘
```
