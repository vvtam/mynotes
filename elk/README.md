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

### 滚动重启节点

1. 可能的话，停止索引新的数据。虽然不是每次都能真的做到，但是这一步可以帮助提高恢复速度。

2. 禁止分片分配。这一步阻止 Elasticsearch 再平衡缺失的分片，直到你告诉它可以进行了。如果你知道维护窗口会很短，这个主意棒极了。你可以像下面这样禁止分配：

   ```js
   PUT /_cluster/settings
   curl -X PUT "localhost:9200/_cluster/settings?pretty" -H 'Content-Type: application/json' -d'
   {
       "transient" : {
           "cluster.routing.allocation.enable" : "none"
       }
   }'
   ```

3. 关闭单个节点。

4. 执行维护/升级。

5. 重启节点，然后确认它加入到集群了。

6. 用如下命令重启分片分配：

   ```js
   PUT /_cluster/settings
   curl -X PUT "localhost:9200/_cluster/settings?pretty" -H 'Content-Type: application/json' -d'
   {
       "transient" : {
           "cluster.routing.allocation.enable" : "all"
       }
   }'
   ```

   分片再平衡会花一些时间。一直等到集群变成 `绿色` 状态后再继续。

7. 重复第 2 到 6 步操作剩余节点。

8. 到这步你可以安全的恢复索引了（如果你之前停止了的话），不过等待集群完全均衡后再恢复索引，也会有助于提高处理速度。

## Logstash

Logstash 是免费且开放的服务器端数据处理管道，能够从多个来源采集数据，转换数据，然后将数据发送到您最喜欢的“存储库”中。

`/web/soft/logstash-6.5.4/bin/logstash -f /web/soft/elasticsearch-6.5.4/config-mysql/mysql_content.conf`



### Running Logstash from the Command Line

To run Logstash from the command line, use the following command:

```shell
bin/logstash [options]
```



To run Logstash from the Windows command line, use the following command:

```shell
bin/logstash.bat [options]
```



Where `options` are [command-line](https://www.elastic.co/guide/en/logstash/6.6/running-logstash-command-line.html#command-line-flags) flags that you can specify to control Logstash execution. The location of the `bin` directory varies by platform. See [Logstash Directory Layout](https://www.elastic.co/guide/en/logstash/6.6/dir-layout.html) to find the location of `bin\logstash` on your system.

The following example runs Logstash and loads the Logstash config defined in the `mypipeline.conf` file:

```shell
bin/logstash -f mypipeline.conf
```



Any flags that you set at the command line override the corresponding settings in [logstash.yml](https://www.elastic.co/guide/en/logstash/6.6/logstash-settings-file.html), but the file itself is not changed. It remains as-is for subsequent Logstash runs.

Specifying command line options is useful when you are testing Logstash. However, in a production environment, we recommend that you use [logstash.yml](https://www.elastic.co/guide/en/logstash/6.6/logstash-settings-file.html) to control Logstash execution. Using the settings file makes it easier for you to specify multiple options, and it provides you with a single, versionable file that you can use to start up Logstash consistently for each run.

### Command-Line Flags

Logstash has the following flags. You can use the `--help` flag to display this information.

- `--node.name NAME`

  Specify the name of this Logstash instance. If no value is given it will default to the current hostname.

- `-f, --path.config CONFIG_PATH`

  Load the Logstash config from a specific file or directory. If a directory is given, all files in that directory will be concatenated in lexicographical order and then parsed as a single config file. Specifying this flag multiple times is not supported. If you specify this flag multiple times, Logstash uses the last occurrence (for example, `-f foo -f bar` is the same as `-f bar`).You can specify wildcards ([globs](https://www.elastic.co/guide/en/logstash/6.6/glob-support.html)) and any matched files will be loaded in the order described above. For example, you can use the wildcard feature to load specific files by name:`bin/logstash --debug -f '/tmp/{one,two,three}'`With this command, Logstash concatenates three config files, `/tmp/one`, `/tmp/two`, and `/tmp/three`, and parses them into a single config.

- `-e, --config.string CONFIG_STRING`

  Use the given string as the configuration data. Same syntax as the config file. If no input is specified, then the following is used as the default input: `input { stdin { type => stdin } }` and if no output is specified, then the following is used as the default output: `output { stdout { codec => rubydebug } }`. If you wish to use both defaults, please use the empty string for the `-e` flag. The default is nil.

- `--java-execution`

  Use the Java execution engine instead of the default Ruby execution engine.

- `--modules`

  Launch the named module. Works in conjunction with the `-M` option to assign values to default variables for the specified module. If `--modules` is used on the command line, any modules in `logstash.yml` will be ignored, as will any settings there. This flag is mutually exclusive to the `-f` and `-e` flags. Only one of `-f`, `-e`, or `--modules` may be specified. Multiple modules can be specified by separating them with a comma, or by invoking the `--modules` flag multiple times.

- `-M, --modules.variable`

  Assign a value to a configurable option for a module. The format for assigning variables is `-M "MODULE_NAME.var.PLUGIN_TYPE.PLUGIN_NAME.KEY_NAME=value"` for Logstash variables. For other settings, it will be `-M "MODULE_NAME.KEY_NAME.SUB_KEYNAME=value"`. The `-M` flag can be used as many times as is necessary. If no `-M` options are specified, then the default value for that setting will be used. The `-M` flag is only used in conjunction with the `--modules` flag. It will be ignored if the `--modules` flag is absent.

- `--pipeline.id ID`

  Sets the ID of pipeline. The default is `main`.

- `-w, --pipeline.workers COUNT`

  Sets the number of pipeline workers to run. This option sets the number of workers that will, in parallel, execute the filter and output stages of the pipeline. If you find that events are backing up, or that the CPU is not saturated, consider increasing this number to better utilize machine processing power. The default is the number of the host’s CPU cores.

- `-b, --pipeline.batch.size SIZE`

  Size of batches the pipeline is to work in. This option defines the maximum number of events an individual worker thread will collect from inputs before attempting to execute its filters and outputs. The default is 125 events. Larger batch sizes are generally more efficient, but come at the cost of increased memory overhead. You may need to increase JVM heap space in the `jvm.options` config file. See [Logstash Configuration Files](https://www.elastic.co/guide/en/logstash/6.6/config-setting-files.html) for more info.

- `-u, --pipeline.batch.delay DELAY_IN_MS`

  When creating pipeline batches, how long to wait while polling for the next event. This option defines how long in milliseconds to wait while polling for the next event before dispatching an undersized batch to filters and outputs. The default is 50ms.

- `--pipeline.unsafe_shutdown`

  Force Logstash to exit during shutdown even if there are still inflight events in memory. By default, Logstash will refuse to quit until all received events have been pushed to the outputs. Enabling this option can lead to data loss during shutdown.

- `--path.data PATH`

  This should point to a writable directory. Logstash will use this directory whenever it needs to store data. Plugins will also have access to this path. The default is the `data` directory under Logstash home.

- `-p, --path.plugins PATH`

  A path of where to find custom plugins. This flag can be given multiple times to include multiple paths. Plugins are expected to be in a specific directory hierarchy: `PATH/logstash/TYPE/NAME.rb` where `TYPE` is `inputs`, `filters`, `outputs`, or `codecs`, and `NAME` is the name of the plugin.

- `-l, --path.logs PATH`

  Directory to write Logstash internal logs to.

- `--log.level LEVEL`

  Set the log level for Logstash. Possible values are:`fatal`: log very severe error messages that will usually be followed by the application aborting`error`: log errors`warn`: log warnings`info`: log verbose info (this is the default)`debug`: log debugging info (for developers)`trace`: log finer-grained messages beyond debugging info

- `--config.debug`

  Show the fully compiled configuration as a debug log message (you must also have `--log.level=debug` enabled). WARNING: The log message will include any *password* options passed to plugin configs as plaintext, and may result in plaintext passwords appearing in your logs!

- `-i, --interactive SHELL`

  Drop to shell instead of running as normal. Valid shells are "irb" and "pry".

- `-V, --version`

  Emit the version of Logstash and its friends, then exit.

- `-t, --config.test_and_exit`

  Check configuration for valid syntax and then exit. Note that grok patterns are not checked for correctness with this flag. Logstash can read multiple config files from a directory. If you combine this flag with `--log.level=debug`, Logstash will log the combined config file, annotating each config block with the source file it came from.

- `-r, --config.reload.automatic`

  Monitor configuration changes and reload whenever the configuration is changed. NOTE: Use SIGHUP to manually reload the config. The default is false.

- `--config.reload.interval RELOAD_INTERVAL`

  How frequently to poll the configuration location for changes. The default value is "3s".

- `--http.host HTTP_HOST`

  Web API binding host. This option specifies the bind address for the metrics REST endpoint. The default is "127.0.0.1".

- `--http.port HTTP_PORT`

  Web API http port. This option specifies the bind port for the metrics REST endpoint. The default is 9600-9700. This setting accepts a range of the format 9600-9700. Logstash will pick up the first available port.

- `--log.format FORMAT`

  Specify if Logstash should write its own logs in JSON form (one event per line) or in plain text (using Ruby’s Object#inspect). The default is "plain".

- `--path.settings SETTINGS_DIR`

  Set the directory containing the `logstash.yml` [settings file](https://www.elastic.co/guide/en/logstash/6.6/logstash-settings-file.html) as well as the log4j logging configuration. This can also be set through the LS_SETTINGS_DIR environment variable. The default is the `config` directory under Logstash home.

- `-h, --help`

  Print help



### Shutting Down Logstash

If you’re running Logstash as a service, use one of the following commands to stop it:

- On systemd, use:

  ```shell
  systemctl stop logstash
  ```

- On upstart, use:

  ```shell
  initctl stop logstash
  ```

- On sysv, use:

  ```shell
  /etc/init.d/logstash stop
  ```

If you’re running Logstash directly in the console on a POSIX system, you can stop it by sending SIGTERM to the Logstash process. For example:

```shell
kill -TERM {logstash_pid}
```



Alternatively, enter **Ctrl-C** in the console.

## Beat

Beats 是一个免费且开放的平台，集合了多种单一用途数据采集器。它们从成百上千或成千上万台机器和系统向 Logstash 或 Elasticsearch 发送数据。