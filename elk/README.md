# ELK日志系统

## Kibana

Kibana 是一个免费且开放的用户界面，能够让您对 Elasticsearch 数据进行可视化，并让您在 Elastic Stack 中进行导航。您可以进行各种操作，从跟踪查询负载，到理解请求如何流经您的整个应用，都能轻松完成。

## Elasticsearch

Elasticsearch 是一个分布式、RESTful 风格的搜索和数据分析引擎，能够解决不断涌现出的各种用例。 作为 Elastic Stack 的核心，它集中存储您的数据，帮助您发现意料之中以及意料之外的情况。

不能使用root运行，配置JAVA_HOME

新建用户

`useradd -s /sbin/nologin -M elasticsearch`

验证

```
curl -XGET 'http://localhost:9200/'
curl -XGET 'http://localhost:9200/_cluster/health?pretty'
# 分片状态查看
curl -XGET 'http://localhost:9200/_cat/shards?v'
# 查看unsigned 的原因
curl -GET 'http://localhost:9200/_cluster/allocation/explain'
# 查看集群中不同节点、不同索引的状态
curl -GET 'http://localhost:9200/_cat/shards?h=index,shard,prirep,state,unassigned.reason'
```

### 常用查询

```
检查索引映射
curl -XGET 'http://10.191.184.104:9200/iptv-nginx-2021-08-09/_mapping?pretty' 

获取一些文档
curl -XGET 'http://10.191.184.104:9200/iptv-nginx-2021-08-09/_search?pretty'

查看数据数量
curl -XGET 'http://10.191.184.104:9200/iptv-nginx-2021-08-09/_count?pretty'

curl -XGET 'http://10.191.184.104:9200/iptv-nginx-2021-08-09/_search?pretty='  -d '
 {
"query":{  
      "match":{  
         "project" : "xxx"
      }
 }'
```



### 重启elasticsearch集群

1. **Disable shard allocation.**

   When you shut down a data node, the allocation process waits for `index.unassigned.node_left.delayed_timeout` (by default, one minute) before starting to replicate the shards on that node to other nodes in the cluster, which can involve a lot of I/O. Since the node is shortly going to be restarted, this I/O is unnecessary. You can avoid racing the clock by [disabling allocation](https://www.elastic.co/guide/en/elasticsearch/reference/current/modules-cluster.html#cluster-routing-allocation-enable) of replicas before shutting down [data nodes](https://www.elastic.co/guide/en/elasticsearch/reference/current/modules-node.html#data-node):

   ```console
   PUT _cluster/settings
   
   curl -X PUT "localhost:9200/_cluster/settings?pretty" -H 'Content-Type: application/json' -d'
   {
     "persistent": {
       "cluster.routing.allocation.enable": "primaries"
     }
   }
   ```

2. **Stop indexing and perform a synced flush.**

   Performing a [synced-flush](https://www.elastic.co/guide/en/elasticsearch/reference/current/indices-synced-flush-api.html) speeds up shard recovery.

   ```console
   POST _flush/synced
   
   curl -X POST "localhost:9200/_flush/synced?pretty"
   ```

   When you perform a synced flush, check the response to make sure there are no failures. Synced flush operations that fail due to pending indexing operations are listed in the response body, although the request itself still returns a 200 OK status. If there are failures, reissue the request.

   Note that synced flush is deprecated and will be removed in 8.0. A flush has the same effect as a synced flush on Elasticsearch 7.6 or later.

3. **Temporarily stop the tasks associated with active machine learning jobs and datafeeds.** (Optional)

   Machine learning features require specific [subscriptions](https://www.elastic.co/subscriptions).

   You have two options to handle machine learning jobs and datafeeds when you shut down a cluster:

   - Temporarily halt the tasks associated with your machine learning jobs and datafeeds and prevent new jobs from opening by using the [set upgrade mode API](https://www.elastic.co/guide/en/elasticsearch/reference/current/ml-set-upgrade-mode.html):

     ```console
     POST _ml/set_upgrade_mode?enabled=true
     ```

     When you disable upgrade mode, the jobs resume using the last model state that was automatically saved. This option avoids the overhead of managing active jobs during the shutdown and is faster than explicitly stopping datafeeds and closing jobs.

   - [Stop all datafeeds and close all jobs](https://www.elastic.co/guide/en/machine-learning/7.13/stopping-ml.html). This option saves the model state at the time of closure. When you reopen the jobs after the cluster restart, they use the exact same model. However, saving the latest model state takes longer than using upgrade mode, especially if you have a lot of jobs or jobs with large model states.

4. **Shut down all nodes.**

   - If you are running Elasticsearch with `systemd`:

     ```sh
     sudo systemctl stop elasticsearch.service
     ```

   - If you are running Elasticsearch with SysV `init`:

     ```sh
     sudo -i service elasticsearch stop
     ```

   - If you are running Elasticsearch as a daemon:

     ```sh
     kill $(cat pid)
     ```

5. **Perform any needed changes.**

6. **Restart nodes.**

   If you have dedicated master nodes, start them first and wait for them to form a cluster and elect a master before proceeding with your data nodes. You can check progress by looking at the logs.

   As soon as enough master-eligible nodes have discovered each other, they form a cluster and elect a master. At that point, you can use the [cat health](https://www.elastic.co/guide/en/elasticsearch/reference/current/cat-health.html) and [cat nodes](https://www.elastic.co/guide/en/elasticsearch/reference/current/cat-nodes.html) APIs to monitor nodes joining the cluster:

   ```console
   GET _cat/health
   GET _cat/nodes
   
   curl -X GET "localhost:9200/_cat/health?pretty"
   curl -X GET "localhost:9200/_cat/nodes?pretty"
   ```

   The `status` column returned by `_cat/health` shows the health of each node in the cluster: `red`, `yellow`, or `green`.

7. **Wait for all nodes to join the cluster and report a status of yellow.**

   When a node joins the cluster, it begins to recover any primary shards that are stored locally. The [`_cat/health`](https://www.elastic.co/guide/en/elasticsearch/reference/current/cat-health.html) API initially reports a `status` of `red`, indicating that not all primary shards have been allocated.

   Once a node recovers its local shards, the cluster `status` switches to `yellow`, indicating that all primary shards have been recovered, but not all replica shards are allocated. This is to be expected because you have not yet re-enabled allocation. Delaying the allocation of replicas until all nodes are `yellow` allows the master to allocate replicas to nodes that already have local shard copies.

8. **Re-enable allocation.**

   When all nodes have joined the cluster and recovered their primary shards, re-enable allocation by restoring `cluster.routing.allocation.enable` to its default:

   ```console
   PUT _cluster/settings
   
   curl -X PUT "localhost:9200/_cluster/settings?pretty" -H 'Content-Type: application/json' -d'
   {
     "persistent": {
       "cluster.routing.allocation.enable": null
     }
   }
   ```

   Once allocation is re-enabled, the cluster starts allocating replica shards to the data nodes. At this point it is safe to resume indexing and searching, but your cluster will recover more quickly if you can wait until all primary and replica shards have been successfully allocated and the status of all nodes is `green`.

   You can monitor progress with the [`_cat/health`](https://www.elastic.co/guide/en/elasticsearch/reference/current/cat-health.html) and [`_cat/recovery`](https://www.elastic.co/guide/en/elasticsearch/reference/current/cat-recovery.html) APIs:

   ```console
   GET _cat/health
   GET _cat/recovery
   
   curl -X GET "localhost:9200/_cat/health?pretty"
   curl -X GET "localhost:9200/_cat/recovery?pretty"
   ```

9. **Restart machine learning jobs.** (Optional)

   If you temporarily halted the tasks associated with your machine learning jobs, use the [set upgrade mode API](https://www.elastic.co/guide/en/elasticsearch/reference/current/ml-set-upgrade-mode.html) to return them to active states:

   ```console
   POST _ml/set_upgrade_mode?enabled=false
   ```

   If you closed all machine learning jobs before stopping the nodes, open the jobs and start the datafeeds from Kibana or with the [open jobs](https://www.elastic.co/guide/en/elasticsearch/reference/current/ml-open-job.html) and [start datafeed](https://www.elastic.co/guide/en/elasticsearch/reference/current/ml-start-datafeed.html) APIs.

## Logstash

Logstash 是免费且开放的服务器端数据处理管道，能够从多个来源采集数据，转换数据，然后将数据发送到您最喜欢的“存储库”中。

`/web/soft/logstash-6.5.4/bin/logstash -f /web/soft/elasticsearch-6.5.4/config-mysql/mysql_content.conf`

## Beat

Beats 是一个免费且开放的平台，集合了多种单一用途数据采集器。它们从成百上千或成千上万台机器和系统向 Logstash 或 Elasticsearch 发送数据。