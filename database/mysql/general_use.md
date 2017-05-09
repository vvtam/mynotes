/usr/local/mysql/bin/mysqld --initialize  初始化数据库  

GRANT ALL PRIVILEGES ON database.tables TO 'user'@'xxx' IDENTIFIED BY 'passwd';  

for new version,change the password  
UPDATE mysql.user SET authentication_string=PASSWORD('newpasswd') WHERE user='xxx';  

SET PASSWORD FOR 'root'@'localhost' = PASSWORD('admin');

CREATE DATABASE mycat DEFAULT CHARACTER SET utf8;
CREATE DATABASE testdb DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;  

CREATE USER 'mycat'@'localhost' IDENTIFIED BY 'mycat2016';

GRANT ALL PRIVILEGES ON mycat.* TO 'mycat'@'localhost' IDENTIFIED BY 'mycat2016';

GRANT ALL PRIVILEGES ON mycat.* TO 'mycat'@'127.0.0.1' IDENTIFIED BY 'mycat2016';

GRANT ALL PRIVILEGES ON mycat.* TO 'mycat'@'%' IDENTIFIED BY 'mycat2016';

mysql> CREATE USER 'repl'@'%' IDENTIFIED BY 'password';  
mysql> GRANT REPLICATION SLAVE ON *.* TO 'repl'@'%';  

```
mysql> CHANGE MASTER TO
    -> MASTER_HOST='192.168.0.180',
    -> MASTER_USER='repl',
    -> MASTER_PASSWORD='password',
    -> MASTER_LOG_FILE='mysql-bin.000001',
    -> MASTER_LOG_POS=595;
```
DELETE FROM video_play_log WHERE dt < DATE_SUB(CURDATE(),INTERVAL 2 MONTH)

CREATE TABLE newtable LIKE oldtable;   
INSERT newtable SELECT * FROM oldtable;  

修改密码
```
skip-grant-tables # mysqld段配置,重启
无密码登录，修改密码
UPDATE mysql.user SET authentication_string=PASSWORD('newpw') WHERE user='root';
#skip-grant-tables 注释重启
新密码登录,并修改密码
ALTER USER 'root'@'localhost' IDENTIFIED BY 'newpw';
```
