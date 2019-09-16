#!/bin/bash
CURL=$(which curl)
function active {
  $CURL "http://127.0.0.1:80/nginx_status/" 2>/dev/null | grep 'Active' | awk '{print $NF}'
}
function reading {
  $CURL "http://127.0.0.1:80/nginx_status/" 2>/dev/null| grep 'Reading' |  awk '{print $2}'
}
function writing {
  $CURL "http://127.0.0.1:80/nginx_status/" 2>/dev/null| grep 'Writing' | awk '{print $4}'
}
function waiting {
  $CURL "http://127.0.0.1:80/nginx_status/" 2>/dev/null| grep 'Waiting' | awk '{print $6}'
}
function accepts {
  $CURL "http://127.0.0.1:80/nginx_status/" 2>/dev/null| awk NR==3 | awk '{print $1}'
}
function handled {
  $CURL "http://127.0.0.1:80/nginx_status/" 2>/dev/null| awk NR==3 |awk '{print $2}'
}
function requests {
  $CURL "http://127.0.0.1:80/nginx_status/" 2>/dev/null| awk NR==3 |awk '{print $3}'
}

#qps
function qps() {
    Qps1=`$CURL -s  "http://127.0.0.1:80/nginx_status/" | awk '/server accepts handled requests/ {getline a;split(a,s); print s[length(s)]}'`

    sleep 1

    Qps2=`$CURL -s  "http://127.0.0.1:80/nginx_status/" | awk '/server accepts handled requests/ {getline a;split(a,s); print s[length(s)]}'`

    if [ $Qps2 -gt 0 ]
    then
    QPS=`expr $Qps2 - $Qps1`
    #QPS=`expr $QINGQIU / 5`
    echo $QPS
    fi
}
# Run the requested function
$1