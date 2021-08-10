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
# 安装rvm
curl -L get.rvm.io | bash -s stable
# 上语句报错后执行下面
curl -sSL https://rvm.io/mpapis.asc | gpg2 --import - 
curl -sSL https://rvm.io/pkuczynski.asc | gpg2 --import -
# 重新下载
curl -L get.rvm.io | bash -s stable
# 设置为环境变量
source /usr/local/rvm/scripts/rvm

# 安装一个ruby版本
rvm install 2.3.3
# 使用一个ruby版本
rvm use 2.3.3


换成下面的
yum install -y centos-release-scl-rh
scl enable rh-ruby24 bash
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

## 新版配置

```
./redis-cli --cluster create 172.16.62.46:6380 172.16.62.46:6381 172.16.62.46:6382 172.16.62.46:6383 172.16.62.45:6380 172.16.62.45:6381 172.16.62.45:6382 172.16.62.45:6383 --cluster-replicas 1
```

