create database cms

create user 'cms'@'127.0.0.1' identified by 'pw';

grant all on cms.* to 'cms'@'127.0.0.1';