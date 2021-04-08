
## consul

./consul agent -server -data-dir=./data/ -node=consul1 -bind=13.16.20.116 -bootstrap-expect=1 -client=13.16.20.116 -log-file ./logs/consul.log -ui



### 介绍

Consul 是 HashiCorp 公司推出的开源工具，用于实现分布式系统的服务发现与配置。通常拿来和zookeeper、etcd这些服务注册与发现的工具进行比较。Consul更像一个“全栈”解决方案，内置了服务注册与发现，具有健康检查、Key/Value存储、多数据中心的功能。

### 特点

1、开箱即用，方便运维：安装包仅包含一个可执行文件，方便部署，无需其他依赖，与Docker等轻量级容器可无缝配合 。

2、自带ui界面，可以通过web界面直接看到注册的服务，更新K/V。

3、采用GOSSIP协议进行集群内成员的管理和消息的传播，使用和etcd一样的raft协议保证数据的一致性。

### 关键特性

1、**服务发现。**提供HTTP和DNS两种发现方式。

2、**健康监测。**支持多种方式，HTTP、TCP、Docker、Shell脚本定制化监控。

3、**KV存储。**Key、Value的存储方式。

4、**多数据中心。**Consul支持多数据中心。

### 安装配置

#### 服务器规划

```
192.168.1.1    consul01
192.168.1.2    consul02
192.168.1.3    onsul03
```

#### 安装

官网下载地址： https://www.consul.io/downloads.html ，此处选择版本 consul_1.5.2_linux_amd64

```bash
wget https://releases.hashicorp.com/consul/1.5.2/consul_1.5.2_linux_amd64.zip
```

创建consul安装目录，/web/soft/consul ,将consul解压到其中

```bash
unzip consul_1.5.2_linux_amd64.zip -d /web/soft/consul
# 添加执行权限
chmod +x /web/soft/consul/consul
```

创建consul的启动配置文件

`data_dir` 需要提前创建好，IP及节点名 根据每台信息自行修改

```
/web/soft/consul/consul_config.json
{
  "datacenter": "consul-cluster",
  "node_name": "consul01",
  "bind_addr": "192.168.1.1",
  "client_addr": "192.168.1.1",
  "server": true,
  "bootstrap_expect": 3,
  "data_dir": "/web/data/consul/data",
  "http_config": {
    "response_headers": {
      "Access-Control-Allow-Origin": "*"
    }
  },
  "log_level": "INFO",
  "ports": {
    "http": 8500,
    "dns": 8600,
    "serf_lan": 8301,
    "serf_wan": 8302
  },
  "enable_script_checks": true
}
```

参数解释：

```
bind_addr: 同命令行的-bind参数，内部集群通信绑定的地址。默认是‘0.0.0.0’，如果有多块网卡，需要指定，否则启动报错
client_addr：同命令行的-clinet参数，客户端接口绑定的地址，默认是‘127.0.0.1’；
server：true指定consul agent的模式为server模式；
bootstrap_expect：同命令行的-bootstrap-expect,集群预期的server个数，这里我们有3台server，设置为3；不能和    bootstrap参数一同使用。
enable_syslog：启用则consul的日志会写进系统的syslog里；
enable_script_checks：是否启用监控检测脚本。
```

#### 启动consul agent

```bash
./consul agent -config-file consul_config.json -log-file ./logs/consul.log -ui
```

指定配置文件位置、日志文件位置，并启动ui界面。在其他节点进行相同的操作

把agent加入到集群

告诉第二个agent，加入到第一个agent里：

```bash
./consul join -http-addr http://192.168.1.2:8500 192.168.1.1
```



在其余节点上，更改自己的http-addr，执行相同的操作

**特别提示**：加入集群的时候，一个consul agent只需要知道集群中任意一个节点即可，加入到集群之后，集群节点之间会根据GOSSIP协议互相发现彼此的关系。

### 集群检查

所有节点都启动成功之后可以查看集群成员是否全部加入成功，任意节点上执行命令：

```bash
./consul members
```

可在日志中查看当前节点是否是主节点

### 单机启动

```bash
nohup ./consul agent -server -data-dir=/web/soft/consul/data/ -node=agent-one -bind=0.0.0.0 -bootstrap-expect=1 -client=0.0.0.0 -log-file ./logs/consul.log -ui &
```

### 登陆WEB UI

浏览器中输入http://192.168.1.1:8500