导出指定表的结构和数据
```
mysqldump -h127.0.0.1 -uuser -p'Passwd' dbname --tables \
table1 \
table2 \
table3 > bak.sql

mysqldump -h127.0.0.1 -uuser -p'Passwd' dbname \
--ignore-table=database.table1 \
--ignore-table=database.table2 \
--ignore-table=database.table3 > bak.sql

```
