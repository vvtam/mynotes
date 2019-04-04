use db #使用或者创建db  
db     #当前db  
show dbs #列出数据库   

无认证启动  
```
/usr/local/mongodb/bin/mongod --storageEngine wiredTiger -dbpath=/data/mongodb --fork --bind_ip_all --port 27017 --logpath=/data/mongodb/mongodb.log --logappend
```

关闭  
```
/usr/local/mongodb/bin/mongod --storageEngine wiredTiger -dbpath=/data/mongodb --fork --bind_ip_all --port 27017 --logpath=/data/mongodb/mongodb.log --logappend --shutdown
```

创建管理员账号      
```
use admin
db.createUser(
  {
    user: "admin",
    pwd: "adfasdfasdfasdfasdf",
    roles:[{role: "userAdminAnyDatabase",db:"admin"}]
  }
)
```

新建用户并授权    
```
use dbname
db.createUser(
  {
    user: "user",
    pwd: "adfaf23sfasdf",
    roles:[{role: "readWrite",db:"dbname"}]
  }
)
```
开启认证
```
/usr/local/mongodb/bin/mongod --storageEngine wiredTiger -dbpath=/data/mongodb --fork --bind_ip_all --port 27017 --logpath=/data/mongodb/mongodb.log --logappend --auth
```