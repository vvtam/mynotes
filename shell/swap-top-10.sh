#!/bin/bash

## copyt right
## https://access.redhat.com/solutions/33375

ps ax -o pid,args | grep -v '^  PID'|sed -e 's,^ *,,' > /tmp/ps_ax.output
echo -n >/tmp/results

for swappid in $(grep -l Swap /proc/[1-9]*/smaps ); do
        swapusage=0
        for x in $( grep Swap $swappid 2>/dev/null |grep -v '\W0 kB'|awk '{print $2}' ); do
                let swapusage+=$x
        done
        pid=$(echo $swappid| cut -d' ' -f3|cut -d'/' -f3)
        if ( [ $swapusage -ne 0 ] ); then
                echo -ne "$swapusage kb\t\t" >>/tmp/results
                egrep "^$pid " /tmp/ps_ax.output |sed -e 's,^[0-9]* ,,' >>/tmp/results
        fi
done

echo "top swap using processes which are still running:"
sort -nr /tmp/results | head -n 10

## If the above script produces no output, then it could be that none of the currently running processes in /proc/*/smaps are using swap. You can test that by simply running

# grep Swap /proc/[1-9]*/smaps | head -n 10
