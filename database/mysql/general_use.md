GRANT ALL PRIVILEGES ON database.tables TO 'user'@'xxx' IDENTIFIED BY 'passwd';  
for new version,change the password  
UPDATE mysql.user SET authentication_string=PASSWORD('newpasswd') WHERE user='xxx';  

CREATE DATABASE mycat DEFAULT CHARACTER SET utf8;

CREATE USER mycat IDENTIFIED BY 'mycat2016';

GRANT ALL PRIVILEGES ON mycat.* TO 'mycat'@'localhost' IDENTIFIED BY 'mycat2016';

GRANT ALL PRIVILEGES ON mycat.* TO 'mycat'@'127.0.0.1' IDENTIFIED BY 'mycat2016';

GRANT ALL PRIVILEGES ON mycat.* TO 'mycat'@'%' IDENTIFIED BY 'mycat2016';