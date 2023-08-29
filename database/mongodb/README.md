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
    user: 'admin',
    pwd: 'password',
    roles: [ { role: 'root', db: 'admin' } ]
  }
);
exit;
If you have already created the admin user, you can change the role like this:

use admin;
db.grantRolesToUser('admin', [{ role: 'root', db: 'admin' }])

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
    roles:[{role: "dbOwner",db:"dbname"}]
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

## 基本使用

use db
show tables
show collections
db.getCollectionNames()

db.表.find({}).count()

db.表.findOne({})

导出csv

/web/soft/mongodb/bin/mongoexport --port 27017 -d db -c collection --query '{"xx":{"$ne":null}}' --type=csv -f xx,xx -o output.csv

导出json

mongoexport -u user -p password --host ip:port -d db -c collection --type=json -o xx.json

mongoexport --host 10.13.6.24:27020 --authenticationDatabase hgdb -u auxmt -p 'pw' -d hgdb -c OrderRequest --query '{"responseBody":{"$regex":"\":\"202012"}}' --type=json -o output.json

mongoexport -u -p '' --authenticationDatabase=admin --host 192.168.254.243:8635 -d xx-c xx--type=json -o xxx.json

查询 

gte，greater than and equal

db.msg_history_for_statistics.find({"createTime" : {"$gte" :  ISODate("2020-11-01T00:00:00.000Z")}})

聚合查询

```
db.msg_history.aggregate([
    {$match: {"createTime" : {"$gte" :  ISODate("2020-10-31T16:00:00.000Z")}}},
    {
        $project: {
            time: { $dateToString: { format: "%Y-%m-%d", date: "$createTime" } },
        }
    },
    { $group: { _id: "$time", count: { $sum: 1 } } },
    { $sort: { "_id": -1 } },
    { $project: { count: 1, 日期: { $toUpper: "$_id" }, _id: 0 } }
])
```

The following example returns various size values in kilobytes:

```
db.stats(1024)
```