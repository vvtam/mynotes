#!/usr/bin/env bash
# Description:  Script for disk monitoring

NUMBER=0
FROMFILE=$1
DISK=$2
METRIC=$3

[[ $# -lt 3 ]] && { echo "FATAL: some parameters not specified"; exit 1; }
[[ -f "$FROMFILE" ]] || { echo "FATAL: datafile not found"; exit 1; }

# Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s avgrq-sz avgqu-sz   await  svctm  %util
case "$3" in
  "rrqm/s")     NUMBER=2;;
  "wrqm/s")     NUMBER=3;;
  "r/s")        NUMBER=4;;
  "w/s")        NUMBER=5;;
  "rKB/s")      NUMBER=6;;
  "wKB/s")      NUMBER=7;;
  "avgrq-sz")   NUMBER=8;;
  "avgqu-sz")   NUMBER=9;;
  "await")      NUMBER=10;;
  "svctm")      NUMBER=11;;
  "util")       NUMBER=12;;
  *)            echo ZBX_NOTSUPPORTED; exit 1 ;;
esac

grep -w $DISK $FROMFILE | tail -n +2 | tr -s ' ' |awk -v N=$NUMBER 'BEGIN {sum=0.0;count=0;} {sum=sum+$N;count=count+1;} END {printf("%.2f\n", sum/count);}'
