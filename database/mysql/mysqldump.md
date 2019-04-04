导出指定表的结构和数据
```
mysqldump -h127.0.0.1 -uuser -p'Passwd' dbname --tables \
table1 \
table2 \
table3 > bak.sql
```
