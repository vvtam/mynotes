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

mysqldump \
--host=1.25.50.47 --user=dbname --password \
dbname \
--ignore-table dbname.device_log \
--ignore-table dbname.manager_group \
--ignore-table dbname.manager_group_item \
--ignore-table dbname.manager_item \
--ignore-table dbname.manager_user \
--ignore-table dbname.manager_user_group \
--ignore-table dbname.statistic \
--ignore-table dbname.user \
--ignore-table dbname.user_age_template \
--ignore-table dbname.user_bind_cellphone \
--ignore-table dbname.user_bind_social \
--ignore-table dbname.user_cellphone \
--ignore-table dbname.user_children \
--ignore-table dbname.user_device \
--ignore-table dbname.user_ext \
--ignore-table dbname.user_login_log \
--ignore-table dbname.user_parental_control \
--ignore-table dbname.user_playcount \
--ignore-table dbname.user_product_package \
--ignore-table dbname.user_product_package_payment \
--ignore-table dbname.user_product_package_renew_log \
--ignore-table dbname.user_video_collect \
--ignore-table dbname.user_video_playlist \
--ignore-table dbname.user_video_playlist_all \
--ignore-table dbname.user_video_praise_log \
--ignore-table dbname.user_video_rating_log \
--ignore-table dbname.user_video_type_playcount \
--ignore-table dbname.business_asset_package \
> dbname.sql
```
