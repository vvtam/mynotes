# zabbixweb接口监控

## 配置

configuration > hosts > web > create web scenario > scenario > steps

## 告警

configuration > hosts > triggers > create trigger >  expression > `{xxx:web.test.fail[xxx].last()}<>0`