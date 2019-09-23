## 自定义node exporter的监控key
比如监控一个url返回的http状态

参考 https://blog.51cto.com/dellinger/2411242

```
#! /bin/bash
prom_file=/data/node_exporter-0.18.1.linux-amd64/key/key.prom
OLD_IFS=$IFS
IFS=";"

export TERM=vt100

key_value="
edu_status  `curl -I -o /dev/null -s -w %{http_code} gxhiedu.com/admin`;
game_status  `curl -I -o /dev/null -s -w %{http_code} gxhiesp.com/admin`"

for i in $key_value
do
    IFS=" "
    j=(`echo $i`)
    key=${j[0]}
    value=${j[1]}
    echo $key $value >> "$prom_file".tmp
done

cat "$prom_file".tmp > $prom_file
rm -rf "$prom_file".tmp
IFS=$OLD_IFS
```
启动node exporter时加上新增key值的路径（文件夹）   
`./node_exporter --collector.textfile.directory=/data/node_exporter-0.18.1.linux-amd64/key`