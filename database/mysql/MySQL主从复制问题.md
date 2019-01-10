# MySQL 主从复制问题
## GTID复制错误
说明：误操作在从库执行了一个sql操作，导致从库不能继续执行

方法：插入空事务

操作：
```
主库：
show master status\G

从库：
show slave status\G
stop slave;
根据从库状态插入空事务
SET GTID_NEXT="id:xxx";
BEGIN;COMMIT;
SET GTID_NEXT="AUTOMATIC";
START SLAVE;
```

## master-to-master复制
```
+--------------------------+-------+
| Variable_name            | Value |
+--------------------------+-------+
| auto_increment_increment | 1     # 增长值 一般设置为master的个数
| auto_increment_offset    | 1     # 初始的值  每个master应该设置不同的值 并且应该小于increment的值
+--------------------------+-------+
# When the value of auto_increment_offset is greater than that of auto_increment_increment, the value of auto_increment_offset is ignored.
```

