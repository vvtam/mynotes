#!/bin/bash
project_process_discovery () { 
process_name=($(cat ./alertscripts/jincheng.txt|grep -v "^#")) 
printf '{\n' 
printf '\t"data":[\n' 
for((i=0;i<${#process_name[@]};++i)) 
{ 
num=$(echo $((${#process_name[@]}-1))) 
if [ "$i" != ${num} ]; 
then 
printf "\t\t{ \n" 
printf "\t\t\t\"{#PNAME}\":\"${process_name[$i]}\"\n\t\t},\n" 
else 
printf "\t\t{ \n" 
printf "\t\t\t\"{#PNAME}\":\"${process_name[$num]}\"\n\t\t}\n\t]\n}\n" 
fi 
} 
} 
 
#web_site_code () { 
#
#}
 
 
case "$1" in 
project_process_discovery) 
project_process_discovery 
;;
process_number_code) 
ps -ef|grep $2 |grep -v 'grep'|grep -v "$0"|wc -l 
#echo $a
#web_site_code $2 
;; 
*) 
 
echo "Usage:$0 {project_process_discovery|process_number_code [process_name]}" 
;; 
esac
