#!/bin/bash
# Author:  yeho <lj2007331 AT gmail.com>
# BLOG:  https://linuxeye.com
#
# Notes: OneinStack for CentOS/RedHat 6+ Debian 8+ and Ubuntu 14+
#
# Project home page:
#       https://oneinstack.com
#       https://github.com/oneinstack/oneinstack

# Modified by xxx
# install redis server and sentinel

yum -y install redhat-lsb-core gcc make

soft_dir=$(pwd)
redis_ver=6.2.13
redis_install_dir=/data/thirdAssembly/redis

Install_redis_server() {
  pushd ${soft_dir}/src > /dev/null
  tar xzf redis-${redis_ver}.tar.gz
  pushd redis-${redis_ver} > /dev/null
  if [ "${OS_BIT}" == '32' -a "${armplatform}" != 'y' ]; then
    sed -i '1i\CFLAGS= -march=i686' src/Makefile
    sed -i 's@^OPT=.*@OPT=-O2 -march=i686@' src/.make-settings
  fi
  make -j ${nproc}
  if [ -f "src/redis-server" ]; then
    mkdir -p ${redis_install_dir}/{bin,etc,var}
    /bin/cp src/{redis-benchmark,redis-check-aof,redis-check-rdb,redis-cli,redis-sentinel,redis-server} ${redis_install_dir}/bin/
    /bin/cp redis.conf ${redis_install_dir}/etc/
    ln -s ${redis_install_dir}/bin/* /usr/local/bin/
    sed -i 's@pidfile.*@pidfile /var/run/redis/redis.pid@' ${redis_install_dir}/etc/redis.conf
    sed -i "s@logfile.*@logfile ${redis_install_dir}/var/redis.log@" ${redis_install_dir}/etc/redis.conf
    sed -i "s@^dir.*@dir ${redis_install_dir}/var@" ${redis_install_dir}/etc/redis.conf
    sed -i 's@daemonize no@daemonize yes@' ${redis_install_dir}/etc/redis.conf
    sed -i "s@^bind 127.0.0.1@bind 0.0.0.0@" ${redis_install_dir}/etc/redis.conf
    # change the password
    sed -i "s@^# requirepass foobared@requirepass S2yqJBa5yCK53uQ36tfF@" ${redis_install_dir}/etc/redis.conf
    sed -i "s@^# masterauth <master-password>@masterauth S2yqJBa5yCK53uQ36tfF@" ${redis_install_dir}/etc/redis.conf
    # change the master ip and port
    sed -i "s@^# replicaof <masterip> <masterport>@replicaof ip port@" ${redis_install_dir}/etc/redis.conf
    # sentinel
    /bin/cp sentinel.conf ${redis_install_dir}/etc/
    sed -i 's@pidfile.*@pidfile /var/run/redis/redis-sentinel.pid@' ${redis_install_dir}/etc/sentinel.conf
    sed -i 's@daemonize no@daemonize yes@' ${redis_install_dir}/etc/sentinel.conf
    # change the master ip port, password
    sed -i 's@^sentinel monitor mymaster 127.0.0.1 6379 2@sentinel monitor mymaster 192.168.139.28 6379 2@' ${redis_install_dir}/etc/sentinel.conf
    sed -i 's@^# sentinel auth-pass <master-name> <password>@sentinel auth-pass mymaster S2yqJBa5yCK53uQ36tfF@' ${redis_install_dir}/etc/sentinel.conf
    # redis_maxmemory=`expr $Mem / 8`000000
    # [ -z "`grep ^maxmemory ${redis_install_dir}/etc/redis.conf`" ] && sed -i "s@maxmemory <bytes>@maxmemory <bytes>\nmaxmemory `expr $Mem / 8`000000@" ${redis_install_dir}/etc/redis.conf
    echo "${CSUCCESS}Redis-server installed successfully! ${CEND}"
    popd > /dev/null
    rm -rf redis-${redis_ver}
    id -u redis >/dev/null 2>&1
    [ $? -ne 0 ] && useradd -M -s /sbin/nologin redis
    chown -R redis:redis ${redis_install_dir}/{var,etc}

    if [ -e /bin/systemctl ]; then
      /bin/cp ../init.d/redis-server.service /lib/systemd/system/
      sed -i "s@/usr/local/redis@${redis_install_dir}@g" /lib/systemd/system/redis-server.service
      systemctl enable redis-server
    else
      /bin/cp ../init.d/Redis-server-init /etc/init.d/redis-server
      sed -i "s@/usr/local/redis@${redis_install_dir}@g" /etc/init.d/redis-server
      [ "${PM}" == 'yum' ] && { cc start-stop-daemon.c -o /sbin/start-stop-daemon; chkconfig --add redis-server; chkconfig redis-server on; }
      [ "${PM}" == 'apt-get' ] && update-rc.d redis-server defaults
    fi
    #[ -z "`grep 'vm.overcommit_memory' /etc/sysctl.conf`" ] && echo 'vm.overcommit_memory = 1' >> /etc/sysctl.conf
    #sysctl -p
    service redis-server start
    su -s /bin/bash -c "/data/thirdAssembly/redis/bin/redis-sentinel /data/thirdAssembly/redis/etc/sentinel.conf" redis
  else
    rm -rf ${redis_install_dir}
    echo "${CFAILURE}Redis-server install failed, Please contact the author! ${CEND}" && lsb_release -a
    kill -9 $$
  fi
  popd > /dev/null
}

Install_redis_server
