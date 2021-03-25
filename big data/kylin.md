## 部署

### 环境

jdk 1.8

hadoop 2.6.5

zookeeper 3.5.4

hbase 1.2.5

hive 2.1.1

kylin 2.6.4

### 安装

环境变量

```
# zookeeper
export PATH=$PATH:/web/soft/zookeeper-3.5.4-beta/bin
# hadoop
export HADOOP_HOME=/web/soft/hadoop-2.6.5
export HADOOP_PREFIX=/web/soft/hadoop-2.6.5
export PATH=$PATH:$HADOOP_PREFIX/bin
export PATH=$PATH:$HADOOP_PREFIX/sbin
export HADOOP_MAPRED_HOME=${HADOOP_PREFIX}
export HADOOP_COMMON_HOME=${HADOOP_PREFIX}
export HADOOP_HDFS_HOME=${HADOOP_PREFIX}
export YARN_HOME=${HADOOP_PREFIX}
####hadoop-env####
export HADOOP_COMMON_LIB_NATIVE_DIR=${HADOOP_PREFIX}/lib/native
export HADOOP_OPTS="-Djava.library.path=${HADOOP_PREFIX}/lib:${HADOOP_PREFIX}/lib/native"

# hbase
export HBASE_HOME=/web/soft/hbase-1.2.5
export PATH=$PATH:$HBASE_HOME/bin

#set hive
export HIVE_HOME=/web/soft/apache-hive-2.1.1-bin
export CLASSPATH=$CLASSPATH:$HIVE_HOME/lib
export PATH=$PATH:$HIVE_HOME/bin:$HIVE_HOME/conf

# KYLIN
export KYLIN_HOME=/web/soft/apache-kylin-2.6.4-bin
export KYLIN_CONF_HOME=$KYLIN_HOME/conf
export PATH=:$PATH:$KYLIN_HOME/bin:$CATALINE_HOME/bin
export tomcat_root=$KYLIN_HOME/tomcat
export hive_dependency=$HIVE_HOME/conf:$HIVE_HOME/lib/*:$HIVE_HOME/hcatalog/share/hcatalog/hive-hcatalog-core-2.1.1.jar
```

修改 bin/kylin.sh

`export HBASE_CLASSPATH_PREFIX=${tomcat_root}/bin/bootstrap.jar:${tomcat_root}/bin/tomcat-juli.jar:${tomcat_root}/lib/*:$hive_dependency:$HBASE_CLASSPATH_PREFIX`

修改配置kylin.properties

```
# hbase上存储kylin元数据
kylin.metadata.url=kylin_metadata@hbase
# hdfs上kylin工作目录
kylin.env.hdfs-working-dir=/kylin   
# kylin主节点模式，从节点的模式为query
kylin.server.mode=all  
# 集群信息
kylin.rest.servers=node01:7070,node02:7070,node03:7070
# 时区
kylin.web.timezone=GMT+8
kylin.job.retry=2
kylin.job.mapreduce.default.reduce.input.mb=500
kylin.job.concurrent.max.limit=10
kylin.job.yarn.app.rest.check.interval.seconds=10
# build cube 产生的Hive中间表存放的数据库
kylin.job.hive.database.for.intermediatetable=kylin_flat_db
# 不采用压缩
kylin.hbase.default.compression.codec=none 
kylin.job.cubing.inmem.sampling.percent=100
kylin.hbase.regin.cut=5
kylin.hbase.hfile.size.gb=2
# 定义kylin用于MR jobs的job.jar包和hbase的协处理jar包，用于提升性能(添加项)
kylin.job.jar=/web/soft/apache-kylin-2.6.4-bin/lib/kylin-job-2.6.4.jar
kylin.coprocessor.local.jar=/web/soft/apache-kylin-2.6.4-bin/lib/kylin-coprocessor-2.6.4.jar
```

拷贝 hadoop配置文件core-site.xml，hdfs-site.xml到kylin配置目录

启动，会检查各种依赖，会提示各种问题

```bash
bin/kylin.sh start
```

默认访问密码admin/KYLIN

### 初始化

```
bin/sample.sh
```