#!/bin/bash
CURL=`which curl`
function idle {
  $CURL "http://127.0.0.1/php-fpm-status" 2>/dev/null| grep 'idle processes' | awk '{print $3}'
  }
function total {
  $CURL "http://127.0.0.1/php-fpm-status" 2>/dev/null| grep 'total processes' |  awk '{print $3}'
       }
function active {
  $CURL "http://127.0.0.1/php-fpm-status" 2>/dev/null| grep 'active' | awk '{print $3}'|grep -v "process"
       }
function maxprocess {
  $CURL "http://127.0.0.1/php-fpm-status" 2>/dev/null| grep 'max active processes' | awk '{print $4}'
       }
# Run the requested function
$1
