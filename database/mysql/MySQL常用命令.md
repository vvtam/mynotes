# MySQL常用命令

## 新建库
```
CREATE DATABASE mycat DEFAULT CHARACTER SET utf8;
CREATE DATABASE testdb DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;
```
## 新建用户
```
CREATE USER 'repl'@'%' IDENTIFIED BY 'password';
CREATE USER 'db1'@'172.2.16.%' IDENTIFIED BY 'pw1';
```
## 用户权限
```
SHOW GRANTS FOR ''@'';
GRANT ALL PRIVILEGES ON database.tables TO 'user'@'xxx' IDENTIFIED BY 'passwd';
GRANT ALL PRIVILEGES ON mycat.* TO 'mycat'@'%' IDENTIFIED BY 'mycat2016';
```
## 撤销权限
```
REVOKE ALL PRIVILEGES ON *.* FROM ''@'';
REVOKE xxx FROM ''@'';
```
## 查看参数 修改参数
```
SHOW VARIABLES LIKE '%XXX%';
SET GLOBAL XXXXXX=XXXXXX;
```
## 复制
```
## MASTER
mysql> CREATE USER 'repl'@'%' IDENTIFIED BY 'password';  
mysql> GRANT REPLICATION SLAVE ON *.* TO 'repl'@'%';  

mysql> flush tables with read lock;
mysql> show master status;

## SLAVE
mysql> CHANGE MASTER TO
    -> MASTER_HOST='192.168.0.180',
    -> MASTER_USER='repl',
    -> MASTER_PASSWORD='password',
    -> MASTER_LOG_FILE='mysql-bin.000001',
    -> MASTER_LOG_POS=595;
mysql> start slave;
## SLAVE
mysql> unlock tables;
```
## 基于GTID的复制
```
## set down those
--gtid_mode=ON --log-bin --log-slave-updates --enforce-gtid-consistency

mysql> CREATE USER 'repl'@'%' IDENTIFIED BY 'password';  
mysql> GRANT REPLICATION SLAVE ON *.* TO 'repl'@'%';  
mysql> CHANGE MASTER TO MASTER_HOST='172.2.26.9', MASTER_PORT=3306, MASTER_USER='repl', MASTER_PASSWORD='pw', MASTER_AUTO_POSITION = 1;
mysql> start slave
```
## 修改密码
```
UPDATE mysql.user SET authentication_string=PASSWORD('newpasswd') WHERE user='xxx';  
SET PASSWORD FOR 'root'@'localhost' = PASSWORD('admin');
skip-grant-tables # mysqld段配置,重启
无密码登录，修改密码
UPDATE mysql.user SET authentication_string=PASSWORD('newpw') WHERE user='root';
#skip-grant-tables 注释重启
新密码登录,并修改密码
ALTER USER 'root'@'localhost' IDENTIFIED BY 'newpw';
SET PASSWORD = PASSWORD('password');
或者
mysql> alter user 'root'@'localhost' identified by '123';
ERROR 1290 (HY000): The MySQL server is running with the --skip-grant-tables option so it cannot execute this statement  #没有加载权限表

mysql> flush privileges;  #加载权限表
Query OK, 0 rows affected (0.00 sec)

mysql> alter user 'root'@'localhost' identified by '123'; #更新密码
Query OK, 0 rows affected (0.00 sec)
```
## 数据操作
```
DELETE FROM video_play_log WHERE dt < DATE_SUB(CURDATE(),INTERVAL 2 MONTH)
CREATE TABLE newtable LIKE oldtable;
INSERT newtable SELECT * FROM oldtable;  
mysql -uxx -pxx dbname --force < xx.sql > xx.log 2>&1 #强制执行，记录错误

create tables IF NOT EXISTS actor (
    actor_id INT NOT NULL AUTO_INCREMENT,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    PRIMARY KEY ( actor_id )
);
```

## 索引

```
CREATE INDEX index_name ON table_name (column_name)
CREATE UNIQUE INDEX index_name ON table_name (column_name)
show index from table_name;
show keys from table_name;

drop index index_name on table_name;
alter table table_name drop index index_name;
alter table table_name drop primary key;
```

