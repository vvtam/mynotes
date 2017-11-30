```
GRANT ALL PRIVILEGES ON database.tables TO 'user'@'xxx' IDENTIFIED BY 'passwd';  

for new version,change the password  
UPDATE mysql.user SET authentication_string=PASSWORD('newpasswd') WHERE user='xxx';  

SET PASSWORD FOR 'root'@'localhost' = PASSWORD('admin');

CREATE DATABASE mycat DEFAULT CHARACTER SET utf8;
CREATE DATABASE testdb DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;  

GRANT ALL PRIVILEGES ON mycat.* TO 'mycat'@'localhost' IDENTIFIED BY 'mycat2016';

GRANT ALL PRIVILEGES ON mycat.* TO 'mycat'@'127.0.0.1' IDENTIFIED BY 'mycat2016';

GRANT ALL PRIVILEGES ON mycat.* TO 'mycat'@'%' IDENTIFIED BY 'mycat2016';

mysql> CREATE USER 'repl'@'%' IDENTIFIED BY 'password';  
mysql> GRANT REPLICATION SLAVE ON *.* TO 'repl'@'%';  

flush tables with read lock;
show master status;
mysql> CHANGE MASTER TO
    -> MASTER_HOST='192.168.0.180',
    -> MASTER_USER='repl',
    -> MASTER_PASSWORD='password',
    -> MASTER_LOG_FILE='mysql-bin.000001',
    -> MASTER_LOG_POS=595;
start slave;
unlock tables;

CHANGE MASTER TO MASTER_HOST='172.2.26.9', MASTER_PORT=3306, MASTER_USER='repl', MASTER_PASSWORD='pw', MASTER_AUTO_POSITION = 1;

DELETE FROM video_play_log WHERE dt < DATE_SUB(CURDATE(),INTERVAL 2 MONTH)

CREATE TABLE newtable LIKE oldtable;   
INSERT newtable SELECT * FROM oldtable;  

修改密码

skip-grant-tables # mysqld段配置,重启
无密码登录，修改密码
UPDATE mysql.user SET authentication_string=PASSWORD('newpw') WHERE user='root';
#skip-grant-tables 注释重启
新密码登录,并修改密码
ALTER USER 'root'@'localhost' IDENTIFIED BY 'newpw';

SET PASSWORD = PASSWORD('password');

CREATE USER 'repl'@'%' IDENTIFIED BY 'password';
GRANT REPLICATION SLAVE ON *.* TO 'repl'@'%';

CREATE DATABASE db1 DEFAULT CHARACTER SET utf8;
CREATE USER 'db1'@'172.2.16.%' IDENTIFIED BY 'pw1';
GRANT ALL PRIVILEGES ON db1.* TO 'db1'@'172.2.16.%';
```
