GRANT ALL PRIVILEGES ON *.* TO 'user'@'xxx' IDENTIFIED BY 'passwd';  
for new version,change the password  
UPDATE mysql.user set authentication_string=PASSWORD('newpasswd') WHERE user='xxx';  
