# ES 7.13.3 集群部署，增加认证

## 准备工作

ES版本包：ES7.13.3  
版本包下载地址：  
官网（下载慢）：https://www.elastic.co/cn/downloads/elasticsearch  
镜像（华为）：https://mirrors.huaweicloud.com/elasticsearch/  
jdk：使用es自带的jdk（如果系统有自带的JAVA_HOME变量会有影响，需要修改es的bin目录下elasticsearch-env的配置）

## 配置

```
cluster.name: cluster-name
node.name: node13
node.master: true
node.data: true
path.data: /home/data/esdata/
path.logs: /home/data/eslog/
network.host: 0.0.0.0
http.port: 9200
discovery.zen.ping.unicast.hosts: ["192.168.60.13","192.168.60.14","192.168.60.15"]
discovery.zen.minimum_master_nodes: 2
cluster.initial_master_nodes: ["192.168.60.13"]
```

## 插件放到在plugins中

## 添加密码认证

生成证书，elastic-certificates.p12,把该文件copy到另外两台服务器es中相同的位置
```
./bin/elasticsearch-certutil cert -out ./config/elastic-certificates.p12 -pass ""
```

修改配置文件重启
```
xpack.security.enabled: true
xpack.license.self_generated.type: basic
xpack.security.transport.ssl.enabled: true
xpack.security.transport.ssl.verification_mode:certificate
#elastic-certificates.p12 绝对路径
xpack.security.transport.ssl.keystore.path: /home/data/esconfig/elastic-certificates.p12
xpack.security.transport.ssl.truststore.path: /home/data/es/config/elastic-certificates.p12
```
添加密码，可以选择自动生成

./bin/elasticsearch-setup-passwords auto

访问验证

`curl -u elastic:************** -XGET 'http://127.0.0.1:9200/_cat/nodes?v'`