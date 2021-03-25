## 集群

```
#心跳间隔
tickTime=2000
#初始容忍的心跳数
initLimit=10
#等待最大容忍的心跳数
syncLimit=5
#本地保存数据的目录
dataDir=/usr/local/zookeeper-3.5.9/data
#客户端默认端口号
clientPort=2181
#dataLogDir=
server.0=17.3.0.8:2888:3888
server.1=17.3.0.9:2888:3888
server.2=17.3.0.10:2888:3888
```

data目录新建文件myid写入上面的id，比如0，1或者2，对应上面server的配置

```
zkServer.sh start
zkServer.sh status
```



