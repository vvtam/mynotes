#!/bin/bash

# mysqladmin -hip -uroot -p'pw' extended-status -i1 -c2|awk \

mysqladmin -hip -uroot -p'pw' extended-status -i1|awk \
'BEGIN{flag=0;
print "";
print "QPS    TPS    Threads_con  Threads_run";
print "--------------------------------------"}

$2 ~ /Queries$/  {q=$4-lq;lq=$4;}
$2 ~ /Com_commit$/   {c=$4-lc;lc=$4;}
$2 ~ /Com_rollback$/   {r=$4-lr;lr=$4;}
$2 ~ /Threads_connected$/  {tc=$4;}
$2 ~ /Threads_running$/    {tr=$4;

if (flag==0)
{
  flag=1; count=0
}
else
{
  printf "%-6d %-8d %-10d %d \n", q,c+r,tc,tr;
} 

}'
