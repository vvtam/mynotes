# filebeat收集日志传输到logstash分析处理后利用zabbix-sender（zabbix采集器）插件传输到zabbix

logstash 配置文件里面zabbix_host要与zabbix server上面配置的主机名称匹配
logstash 推送到zabbix的key需要提前在zabbix server上面配置

## 实际应用中报错排查

tcpdump抓包发现logstash 已经把数据传输到zabbix server，但是server拒绝没处理。
后面使用 zabbix-sender直接发送成功

`zabbix_sender -z 192.168.0.18 -p 10051 -s "主机名" -k your keys -o "vaule"`

注意到主机名和logstash配置不匹配