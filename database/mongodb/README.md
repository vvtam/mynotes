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

db.adminCommand( { shutdown: 1 } )
```

创建管理员账号      
```
With access control enabled, ensure you have a user with userAdmin or userAdminAnyDatabase role in the admin database. This user can administrate user and roles such as: create users, grant or revoke roles from users, and create or modify customs roles.

use admin
db.createUser(
  {
    user: "admin",
    pwd: "adfasdfasdfasdfasdf",
    roles:[{role: "userAdminAnyDatabase",db:"admin"}]
  }
)

use admin
db.createUser(
  {
    user: "myUserAdmin",
    pwd: passwordPrompt(), // or cleartext password
    roles: [ { role: "userAdminAnyDatabase", db: "admin" }, "readWriteAnyDatabase" ]
  }
)

The database where you create the user (in this example, admin) is the user’s authentication database. Although the user would authenticate to this database, the user can have roles in other databases; i.e. the user’s authentication database does not limit the user’s privileges.
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
security:
    authorization: enabled
    
/usr/local/mongodb/bin/mongod --storageEngine wiredTiger -dbpath=/data/mongodb --fork --bind_ip_all --port 27017 --logpath=/data/mongodb/mongodb.log --logappend --auth
```