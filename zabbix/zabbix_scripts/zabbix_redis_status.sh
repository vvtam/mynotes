#!/bin/bash

export PATH=$PATH:/usr/bin:/bin:/usr/local/bin:/sbin:/usr/sbin:/usr/local/sbin:/usr/local/mysql/bin/

REDIS_BIN=$(which redis-cli)
REDIS_HOST=127.0.0.1
REDIS_PORT=$1
item=$2

${REDIS_BIN} -h ${REDIS_HOST}  -p ${REDIS_PORT} info 2>/dev/null |grep -w ${item}|cut -d : -f2