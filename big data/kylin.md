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

~~修改 bin/kylin.sh~~

~~`export HBASE_CLASSPATH_PREFIX=${tomcat_root}/bin/bootstrap.jar:${tomcat_root}/bin/tomcat-juli.jar:${tomcat_root}/lib/*:$hive_dependency:$HBASE_CLASSPATH_PREFIX~~`

修改配置kylin.properties

```
###hbase上存储kylin元数据
#kylin.metadata.url=kylin_metadata@hbase
###hdfs上kylin工作目录
kylin.env.hdfs-working-dir=/kylin   
#kylin.env=DEV
#kylin.env.zookeeper-base-path=/kylin
###kylin主节点模式，从节点的模式为query，只有这一点不一样
kylin.server.mode=all
# 集群信息
kylin.rest.servers=App-1:7070,App-2:7070,App-3:7070
# 时区
kylin.web.timezone=GMT+8
kylin.job.retry=2
kylin.job.mapreduce.default.reduce.input.mb=500
kylin.job.concurrent.max.limit=10
kylin.job.yarn.app.rest.check.interval.seconds=10
###build cube 产生的Hive中间表存放的数据库
kylin.job.hive.database.for.intermediatetable=kylin_flat_db
###不采用压缩
kylin.hbase.default.compression.codec=none 
kylin.job.cubing.inmem.sampling.percent=100
kylin.hbase.regin.cut=5
kylin.hbase.hfile.size.gb=2
## hbase集群填写hadoop集群信息
kylin.hbase.cluster.fs=hdfs://GS:8020

###定义kylin用于MR jobs的job.jar包和hbase的协处理jar包，用于提升性能(添加项)
kylin.job.jar=/web/soft/apache-kylin-2.6.4-bin/lib/kylin-job-2.6.4.jar
kylin.coprocessor.local.jar=/web/soft/apache-kylin-2.6.4-bin/lib/kylin-coprocessor-2.6.4.jar
```

```
# 使用beeline连接hive
kylin.source.hive.client=beeline
kylin.source.hive.beeline-shell=beeline
kylin.source.hive.enable-sparksql-for-table-ops=false
kylin.source.hive.keep-flat-table=false
kylin.source.hive.database-for-flat-table=kylin_flat_db
kylin.source.hive.redistribute-flat-table=true
kylin.source.hive.beeline-params=-n hadoop --hiveconf hive.security.authorization.sqlstd.confwhitelist.append='mapreduce.job.*|dfs.*' -u jdbc:hive2://13.36.20.6:10000
```

```
beeline连接远程hive报错
hadoop is not allowed to impersonate hadoop

<property>
  <name>hadoop.proxyuser.hadoop.groups</name>
<value>*</value>
</property>

<property>
 <name>hadoop.proxyuser.hadoop.hosts</name>
 <value>*</value>
</property>

hdfs dfsadmin -refreshSuperUserGroupsConfiguration
```



拷贝 hadoop配置文件core-site.xml，hdfs-site.xml到kylin配置目录

拷贝 hive，hbase配置文件到响应的hive hbase配置目录

启动，会检查各种依赖，会提示各种问题

```bash
bin/kylin.sh start
```

默认访问密码admin/KYLIN

### 初始化

```
bin/sample.sh
```

### 其它

如果本机有hbase冲突可以拷贝一份新的，然后把路径加入到 bin/kylin.sh 开头

```
export HBASE_HOME=/web/soft/apache-kylin-2.6.4-bin/hbase-1.2.5
export PATH=$PATH:$HBASE_HOME/bi
```

如果hive设置了系统环境变量，启动还是报错，可以修改bin/find-hive-dependency.sh 文件，比如：

```
hive_conf_path=
hive_exec_path=
```

## 参考安装

```javascript
# 1. java
export JAVA_HOME=/usr/java/jdk1.7.0_80
export CLASSPATH=.:$JAVA_HOME/jre/lib/rt.jar:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar

# 2. Tomcat
#export CATALINA_HOME=/developer/apache-tomcat-7.0.73
#export CATALINA_HOME=/developer/saiku-server/tomcat
export CATALINA_HOME=/developer/apache-kylin-2.3.0-bin/tomcat

# 3. Maven
export MAVEN_HOME=/developer/apache-maven-3.0.5

# 4. hadoop
export HADOOP_HOME=/developer/hadoop-2.6.0

# 5. hbase
export HBASE_HOME=/developer/hbase-1.2.0

# 6. hive
export HIVE_HOME=/developer/apache-hive-1.1.0-bin
export HIVE_CONF_DIR=${HIVE_HOME}/conf
export HCAT_HOME=$HIVE_HOME/hcatalog

# 7. kylin
export KYLIN_HOME=/developer/apache-kylin-2.3.0-bin
export hive_dependency=$HIVE_HOME/conf:$HIVE_HOME/lib/*:$HCAT_HOME/share/hcatalog/hive-hcatalog-core-1.1.0.jar


#Path
# 1. big data
export PATH=$KYLIN_HOME/bin:$PATH
export PATH=$HIVE_HOME/bin:$HBASE_HOME/bin:$HADOOP_HOME/bin:$PATH
export PATH=$MAVEN_HOME/bin:$CATALINA_HOME/bin:$JAVA_HOME/bin:$PATH
```

### 2.配置 kylin.sh

 在文件开始的地方，添加如下配置：

```javascript
export KYLIN_HOME=/developer/apache-kylin-2.3.0-bin

export HBASE_CLASSPATH_PREFIX=$CATALINA_HOME/bin/bootstrap.jar:$CATALINA_HOME/bin/tomcat-juli.jar:$CATALINA_HOME/lib/*:$hive_dependency:$HBASE_CLASSPATH_PREFIX
```

## 四、参考资料

1.[kylin加载hive表错误controller.TableController:189 : org/apache/hadoop/hive/conf/HiveConf java.lang.NoClassDefFoundError: org/apache/hadoop/hive/conf/HiveConf 解决办法](http://www.cnblogs.com/sench/p/kylin.html)

2.[Kylin安装部署](http://www.cnblogs.com/itboys/p/6322421.html)

