# 分片副本集初始化

## init replica

rs.initiate( {
   _id : "rep_shard2",
   members: [
      { _id: 0, host: "113.136.199.130:27019" },
      { _id: 1, host: "113.136.199.147:27019" },
      { _id: 2, host: "113.136.199.148:27019" }
   ]
})
#
rs.conf()
rs.status()

## init config svr

rs.initiate( {
   _id : "confserver",
   configsvr: true,
   members: [
      { _id: 0, host: "113.136.199.130:20000" },
      { _id: 1, host: "113.136.199.147:20000" },
      { _id: 2, host: "113.136.199.148:20000" }
   ]
})

## init mongos

use admin
sh.addShard("rep_shard2/113.136.199.130:27019,113.136.199.147:27019,113.136.199.148:27019")
sh.addShard("rep_shard1/113.136.199.130:27018,113.136.199.147:27018,113.136.199.148:27018")

## 迁移数据

mongodump --port 27077 -u "user" -p "pw" -d db -o output
mongorestore --port 27017 -d db output/db

## 常用命令

 `sh.status()` 查看状态

```
test库启用分片
use admin
sh.enableSharding("test")
```