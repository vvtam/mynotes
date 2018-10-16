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
