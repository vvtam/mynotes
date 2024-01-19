# percona

## percona toolkit
安装

```
wget https://www.percona.com/downloads/percona-toolkit/3.0.3/binary/tarball/percona-toolkit-3.0.3_x86_64.tar.gz
yum install perl perl-devel perl-Time-HiRes perl-DBI perl-DBD-MySQL perl-CPAN perl-Digest-MD5
perl Makefile.PL
make
make install
```
运行pt-table-checksum
```

报错
install_driver(mysql) failed: Attempt to reload DBD/mysql.pm aborted.
 
解决办法：
ln -sv /usr/lib64/mysql/libmysqlclient.so.16 /lib64/

pt-table-checksum --nocheck-binlog-format --nocheck-plan --nocheck-replication-filters  --set-vars innodb_lock_wait_timeout=120 --recursion-method=processlist --databases=dbname -u'user' -p'password' -hMasterIP

pt-table-checksum --nocheck-binlog-format --nocheck-plan --nocheck-replication-filters  --set-vars innodb_lock_wait_timeout=120 --recursion-method=processlist --databases=dbname  -u'user' -p'password' --slave-user='' --slave-password='' -hMasterIP
```
## Percona Xtrabackup

```
# 第一次完整备份
./bin/xtrabackup --defaults-file=/etc/my.cnf --user=root --password='password' --port=3306 --socket=/data/mysql/mysql.sock --backup --target-dir=/home/pxb_backup/full
# 第二次 
If you intend the backup to be the basis for further incremental backups, you should use the xtrabackup --apply-log-only option when preparing the backup, or you will not be able to apply incremental backups to it. See the documentation on preparing [incremental backup] (incremental_backup.md#incremental-backup) for more details.
./bin/xtrabackup --prepare --target-dir=/data/backups/

# 恢复
确认数据库是关闭的，并且datadir，目录下为空(一般备份之前目录，新建mysql的各种目录)
Backup needs to be prepared before it can be restored.
$ xtrabackup --copy-back --target-dir=/data/backups/
If you don’t want to save your backup, you can use the xtrabackup --move-back option which will move the backed up data to the datadir.
If you don’t want to use any of the above options, you can additionally use rsync or cp to restore the files.
Note
The datadir must be empty before restoring the backup. Also it’s important to note that MySQL server needs to be shut down before restore is performed. You can’t restore to a datadir of a running mysqld instance (except when importing a partial backup).
```
## Stream and compress
```
# stream xbstream and compress
./xtrabackup --defaults-file=/etc/my.cnf --host=localhost --port=3306 --user=root --password= --backup --throttle=50 --databases=cms --no-lock --stream=xbstream --parallel=4 --compress --compress-threads=2  --target-dir=/home/percona --extra-lsndir=/home/percona_checkpoint > /home/tmp.xbstream

./xtrabackup --defaults-file=/etc/my.cnf --host=localhost --port=3306 --user=root --password= --backup --databases=cms --no-lock --stream=xbstream --parallel=8 --compress --compress-threads=4  --target-dir=/home/percona --extra-lsndir=/home/percona_checkpoint /home/backup > /home/backup/tmp.xbstream

./xbstream -x < /home/tmp.xbstream -C /home/backup/

# stream tar
./xtrabackup --defaults-file=/etc/my.cnf --host=localhost --port=3306 --user=root --password= --backup --throttle=60 --databases=cms --no-lock --target-dir=/home/percona --extra-lsndir=/home/percona_checkpoint --stream=tar /home/backup > /home/backup/tmp.tar

tar -xizf backup.tar.gz

# stream tar and pigz to gzip
./xtrabackup --defaults-file=/etc/my.cnf --host=localhost --port=3306 --user=root --password= --backup --databases=cms --no-lock --stream=tar --extra-lsndir=/home/percona_checkpoint | pigz -k -v -9 -p 24 -c > /home/tmp.tar.pigz

```
