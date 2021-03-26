# HBASE集群搭建
## 安装
hbase软件目录为/web/soft/,将hadoop安装包解压安装到该目录下
tar xf hbase-1.2.5-bin.tar.gz -C /web/soft/

## 创建数据目录
mkdir /web/data/hbasedata
mkdir /web/data/zkdata

**hdfs**
hadoop fs -mkdir /hbase

## 每台服务器配置环境变量
```shell
# hbase
export HBASE_HOME=/web/soft/hbase-1.2.5
export PATH=$PATH:$HBASE_HOME/bin

#ssh port
export HBASE_SSH_OPTS="-p 17122"
```

## hbase配置文件：
hbase-env.sh
```shell
export JAVA_HOME=/usr/local/jdk1.8.0_171/
export HBASE_MANAGES_ZK=false
export HBASE_PID_DIR=${HBASE_HOME}/pids
```

 hbase-site.xml
```xml
<configuration>
    <property> 
           <name>hbase.rootdir</name> 
        <!--在HDFS上创建一个干净的节点，用于存放元数据-->
           <value>hdfs://HN:8020/hbase</value>  
    </property> 
    <property> 
           <name>hbase.tmp.dir</name> 
           <value>/web/data/hbasedata</value>
    </property> 
    <property> 
           <name>hbase.cluster.distributed</name> 
           <value>true</value> 
    </property> 
    <property> 
           <name>hbase.master</name> 
       <value>60000</value>
    </property> 
    <property> 
           <name>hbase.zookeeper.quorum</name>  
           <value>IPTV-Spark-4,IPTV-Spark-5,IPTV-Spark-6</value> 
    </property> 
    <property> 
        <name>hbase.zookeeper.property.dataDir</name> 
        <value>/web/data/zkdata</value> 
    </property>
    <property>
        <name>hbase.regionserver.wal.codec</name>
        <value>org.apache.hadoop.hbase.regionserver.wal.IndexedWALEditCodec</value>
    </property>
 <property>
    <name>hbase.coprocessor.abortonerror</name>
    <value>false</value>
 </property>
</configuration>
```


**配置regionservers**

```
IPTV-Spark-4
IPTV-Spark-5
IPTV-Spark-6
```

## 拷贝hadoop文件
hdfs-site.xml core-site.xml 拷贝到当前配置文件中



## 同步程序文件到从节点
在IPTV-Spark-4将上面配好的文件复制到各个节点对应的目录：
```shell
scp -r /web/soft/hbase-1.2.5 hadoop@IPTV-Spark-5:/web/soft/
scp -r /web/soft/hbase-1.2.5 hadoop@IPTV-Spark-6:/web/soft/
```



## 启动hbase集群
start-hbase.sh

## 检查
hbase shell
\> status

## 常见问题
**hbase cannot get log reader问题**

hregionserver报以上错误，解决办法：
hbase 版本是1.2.6，下载apache-phoenix-4.14.0-HBase-1.2-bin.tar.gz,将其中phoenix-4.14.0-HBase-1.2-server.jar 放入hbase的lib目录即可解决