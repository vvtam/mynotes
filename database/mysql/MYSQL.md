### MySQL遇见的问题整理

#### Error: 1114 SQLSTATE: HY000 The table '%s' is full

Error: 1114 SQLSTATE: HY000 (ER_RECORD_FILE_FULL)
Message: The table '%s' is full

比如引擎是 memory，就可以在my.cnf增加 max_heap_table_size=1024M这个参数
其它引擎比如 innodb请查阅资料

#### 在命令行用source导入数据时候提示 server gone away，可能是因为允许的包太小了，修改max_allowed_packet或者其它相关参数

`Aborted connection 4680 to db: 'xx' user: 'xx' host: 'xx' (Got an error reading communication packets)`

调整max_allowed_packet，net_buffer_length的值

#### 超时

  `connect_timeout` ，`net_read_timeout` 和 `net_write_timeout`

#### Waiting for table metadata lock
`show processlist;` 显示很多 `Waiting for table metadata lock`

MySQL在进行一些alter table等DDL操作时，如果该表上有未提交的事务则会出现 `Waiting for table metadata lock`,该表后面的操作会阻塞

从 information_schema.innodb_trx 表中查看当前未提交的事务：

`select trx_state, trx_started, trx_mysql_thread_id, trx_query from information_schema.innodb_trx\G`

kill掉线程的id

调整`lock_wait_timeout` 的值

```
show variables like "lock_wait_timeout";
set session lock_wait_timeout = 1800;
set global lock_wait_timeout = 1800;
```
#### 客户端登录查询提示*2027 Malformed packet*
可能是客户端版本和服务端不匹配