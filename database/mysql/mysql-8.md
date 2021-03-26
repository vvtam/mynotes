create database cms

create user 'cms'@'127.0.0.1' identified by 'pw';

grant all on cms.* to 'cms'@'127.0.0.1';



create database 数据库名;
CREATE USER '用户名'@'172.26.17.%' IDENTIFIED WITH mysql_native_password BY '密码'; 
GRANT ALL PRIVILEGES ON 数据库.* TO '用户名'@'172.26.17.%';
flush privileges;