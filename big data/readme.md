## Hadoop

The project includes these modules:

- **Hadoop Common**: The common utilities that support the other Hadoop modules.
- **Hadoop Distributed File System (HDFS™)**: A distributed file system that provides high-throughput access to application data.
- **Hadoop YARN**: A framework for job scheduling and cluster resource management.
- **Hadoop MapReduce**: A YARN-based system for parallel processing of large data sets.
- **[Hadoop Ozone](https://hadoop.apache.org/ozone/)**: An object store for Hadoop.

数据库 Database (Oracle, Mysql, PostgreSQL)主要用于**事务处理**，数据仓库 Datawarehouse (Amazon Redshift, Hive)主要用于**数据分析**。

## HBase-数据库

[Apache](https://www.apache.org/) HBase™ is the [Hadoop](https://hadoop.apache.org/) database, a distributed, scalable, big data store.

Use Apache HBase™ when you need random, realtime read/write access to your Big Data.

## hdfs (*Hadoop Distributed File System*)

```
hadoop dfsadmin -report
hadoop fs -du -h /
hdfs dfs -du -h /
hdfs dfs -cat /data/clientSummary/2021-01-10/xx* | wc -l 统计文件行数
hdfs dfs -count /data/* 统计大小
hdfs dfs -ls /data/*
hdfs dfs -get /data/
```

hadoop 安全模式 ，磁盘不足会进入安全模式

hdfs dfsadmin -safemode enter | leave | get | wait

## hive-数据仓库

The Apache Hive ™ data warehouse software facilitates reading, writing, and managing large datasets residing in distributed storage using SQL. Structure can be projected onto data already in storage. A command line tool and JDBC driver are provided to connect users to Hive.

数据定期从事务系统、[关系数据库](https://aws.amazon.com/cn/relational-database/)和其他来源流入数据仓库，数据仓库通过高效地存储数据以便最大限度地减少数据输入和输出 (I/O)，并快速地同时向成千上万的用户提供查询结果。

数据仓库的架构包含多个层。顶层是通过报告、分析和数据挖掘工具呈现结果的前端客户端。中间层包括用于访问和分析数据的分析引擎。架构的底层是加载和存储数据的数据库服务器。数据使用两种不同类型的方式存储：1) 经常访问的数据存储在最快的存储装置中（例如，SSD 驱动器），2) 不经常访问的数据存储在便宜的对象存储区中，例如 Amazon S3。数据仓库将自动确保经常访问的数据被移进“快速”存储以便优化查询速度。

### hive metastore服务

nohup hive --service metastore & #默认端口9083

## ZooKeeper-分布式协调系统

ZooKeeper is a centralized service for maintaining configuration information, naming, providing distributed synchronization, and providing group services. All of these kinds of services are used in some form or another by distributed applications. Each time they are implemented there is a lot of work that goes into fixing the bugs and race conditions that are inevitable. Because of the difficulty of implementing these kinds of services, applications initially usually skimp on them, which make them brittle in the presence of change and difficult to manage. Even when done correctly, different implementations of these services lead to management complexity when the applications are deployed.

## Flume-日志采集-数据通道

Flume is a distributed, reliable, and available service for efficiently collecting, aggregating, and moving large amounts of log data. It has a simple and flexible architecture based on streaming data flows. It is robust and fault tolerant with tunable reliability mechanisms and many failover and recovery mechanisms. It uses a simple extensible data model that allows for online analytic application.

![Agent component diagram](https://flume.apache.org/_images/DevGuide_image00.png)

## kafka-消息队列

like [ActiveMQ](http://activemq.apache.org/) or [RabbitMQ](https://www.rabbitmq.com/)？

Apache Kafka is an open-source distributed event streaming platform used by thousands of companies for high-performance data pipelines, streaming analytics, data integration, and mission-critical applications.

## presto

Presto is an open source distributed SQL query engine for running interactive analytic queries against data sources of all sizes ranging from gigabytes to petabytes.

Presto was designed and written from the ground up for interactive analytics and approaches the speed of commercial data warehouses while scaling to the size of organizations like Facebook.

launcher run #前台运行

launcher start #后台运行

## 常用端口

hdfs 存储

hdfs name-node                http/50070  node/9000               管理数据

hdfs data-node                  http/50075  node/50010 9000   存储数据

yarn 资源管理，任务调度

yarn resource-manager   http/8088

yarn node-manager          http/8042  8082  8088

 