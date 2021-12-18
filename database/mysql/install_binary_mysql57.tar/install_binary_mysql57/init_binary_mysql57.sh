#!/bin/bash

mysql_version=5.7.33
mysql_install_dir=/web/soft/mysql
mysql_data_dir=/web/data/mysql
mysql_cnf_path=/etc/my.cnf

cd $(pwd)/src
tar xvf mysql-${mysql_version}-linux-glibc2.12-x86_64.tar.gz
mv mysql-${mysql_version}-linux-glibc2.12-x86_64 ${mysql_install_dir}

# add mysql user and group
groupadd mysql
useradd -r -g mysql mysql

# create mysql data dir
[ ! -d ${mysql_data_dir} ] && mkdir -p ${mysql_data_dir}

chown -R mysql: ${mysql_install_dir} ${mysql_data_dir}

# copy my.cnf
cp ../etc/my.cnf ${mysql_cnf_path}

# init mysql with insecure
${mysql_install_dir}/bin/mysqld --defaults-file=${mysql_cnf_path} \
    --initialize --initialize-insecure \
    --basedir=${mysql_install_dir} --datadir=${mysql_data_dir} \
    --user=mysql

# copy mysql init.d and start mysql
cp ../init.d/mysqld /etc/init.d/mysqld
chkconfig --add mysqld
service mysqld start

# update mysql root password
${mysql_install_dir}/bin/mysql -uroot -e "flush privileges; alter user 'root'@'localhost' identified by 'fn2dB2rhn6hBBzgv6KYZ';"

# add mysql to PATH

[ -z "$(grep ^'export PATH=' /etc/profile)" ] && echo "export PATH=${mysql_install_dir}/bin:\$PATH" >> /etc/profile
[ -n "$(grep ^'export PATH=' /etc/profile)" -a -z "$(grep ${mysql_install_dir} /etc/profile)" ] && sed -i "s@^export PATH=\(.*\)@export PATH=${mysql_install_dir}/bin:\1@" /etc/profile
