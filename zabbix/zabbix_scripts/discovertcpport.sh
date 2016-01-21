#!/bin/bash
portarray=(`netstat -tnlp|egrep -i "$1"|awk {'print $4'}|awk -F':' '{if ($NF~/^[0-9]*$/) print $NF}'|sort |uniq   2>/dev/null`)
length=${#portarray[@]}
printf "{\n"
printf  '\t'"\"data\":["
for ((i=0;i<$length;i++))
do
        printf '\n\t\t{'
	processname=$(netstat -tpnl |grep -w "${portarray[$i]}"|awk '{print $7}'|awk -F '/' '{print $NF}'|sort|uniq)
        printf "\"{#TCP_PORT}\":\"${portarray[$i]}\",\"{#PROCESS_NAME}\":\"${processname}\"}"
        if [ $i -lt $[$length-1] ];then
                printf ','
        fi
done
printf  "\n\t]\n"
printf "}\n"
