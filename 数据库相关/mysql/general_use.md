GRANT ALL PRIVILEGES ON database.tables TO 'user'@'xxx' IDENTIFIED BY 'passwd';  
for new version,change the password  
UPDATE mysql.user SET authentication_string=PASSWORD('newpasswd') WHERE user='xxx';  
