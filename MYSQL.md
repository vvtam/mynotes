#MySQL遇见的问题整理

- Error: 1114 SQLSTATE: HY000 The table '%s' is full

> Error: 1114 SQLSTATE: HY000 (ER_RECORD_FILE_FULL)
> Message: The table '%s' is full

比如引擎是 memory，就可以在my.cnf增加 max_heap_table_size=1024M这个参数
其它引擎比如 innodb请查阅资料

- 在命令行用source导入数据时候提示 server gone away，可能是因为允许的包太小了，修改max_allowed_packet或者其它相关参数
