# Replication
## Binary Log File Postion Based Replication
### Master:  
enable binary logging   
configure a unique server ID    
`[mysqld]`   
`log-bin=mysql-bin`   
`server-id=1`        
`skip-networking` is not enable,otherwise the slaves cannot
communicate with the Master   
(require a server restart)   
create a separate user for slaves   
if master already have data on it, create
a database snapshot to copy the data to the salves   
`CREATE USER 'repl'@'%.ip' IDENTIFIED BY 'passwd';`   
`GRANT REPLICATION SLAVE ON *.* TO 'repl'@'%.IP';`     
`FLUSH TABLES WITH READ LOCK;`   
`SHOW MASTER STATUS;`    
if `server-id=0`,the master refuse any connections from slaves      
### Slave:   
unique server ID
(require a server restart)
If you omit server-id (or set it explicitly to its default value of 0), the slave refuses to connect to a master.   
You do not have to enable binary logging on the slave for replication to be set up. However, if you enable binary logging on the slave, you can use the slave's binary log for data backups and crash recovery, and also use the slave as part of a more complex replication topology. For example, where this slave then acts as a master to other slaves.     
```
mysql> CHANGE MASTER TO
    ->     MASTER_HOST='master_host_name',
    ->     MASTER_USER='replication_user_name',
    ->     MASTER_PASSWORD='replication_password',
    ->     MASTER_LOG_FILE='recorded_log_file_name',
    ->     MASTER_LOG_POS=recorded_log_position;
```
Replication cannot use Unix socket files. You must be able to connect to the master MySQL server using TCP/IP.   

### Others
Use InnoDB with transaction for the greatest possible durability
and consistency   
`skip_flush_log_at_trx_commit=1`   
`sync_binlog=1`   
 cold backup and slow shutdown?    
### mysqldump
--all-database --ignore-table --master-data --database   

## Replication with Global Transaction Identifiers
 You can use either statement-based or row-based replication with GTIDs; however, for best results, we recommend that you use the row-based format.   

 do not include MASTER_LOG_FILE or MASTER_LOG_POS options in the CHANGE MASTER TO statement used to direct a slave to replicate from a given master; instead it is necessary only to enable the MASTER_AUTO_POSITION option.    
