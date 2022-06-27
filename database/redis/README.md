## 常用操作

maxmemory

maxmemory-policy 清理策略

```
volatile-lru：从已设置过期时间的数据集（server.db[i].expires）中挑选最近最少使用的数据淘汰
volatile-ttl：从已设置过期时间的数据集（server.db[i].expires）中挑选将要过期的数据淘汰
volatile-random：从已设置过期时间的数据集（server.db[i].expires）中任意选择数据淘汰
allkeys-lru：从数据集（server.db[i].dict）中挑选最近最少使用的数据淘汰
allkeys-random：从数据集（server.db[i].dict）中任意选择数据淘汰
noenviction：禁止驱逐数据，注意这个清理过程是阻塞的，直到清理出足够的内存空间。所以如果在达到maxmemory并且调用方还在不断写入的情况下，可能会反复触发主动清理策略，导致请求会有一定的延迟
```

config get xxx

config set xxx yyy

get info

select num #选择库

flushdb #当前库

flushall #所有库





./redis/bin/redis-cli -h 192.168.166.71 -p 7000 -a SmCm4ErEXyJgpedv -n 3 keys "Playurl*" | xargs ./redis/bin/redis-cli -h 192.168.166.71 -p 7000 -a SmCm4ErEXyJgpedv -n 3 del

type  类型有 string ，hash，set等

hgetall key 

hget key field

hset key field value

SISMEMBER key member

SADD key member

SREM

scard key
