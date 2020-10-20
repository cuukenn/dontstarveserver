#!/bin/bash
#author changgg
pids=$(ps aux | grep dontstarve | awk -v OFS=',' '{print $2,$11}')
array=(${pids// / })
for var in ${array[@]}
do
    item=(${var//,/ })
    result=`echo ${item[1]} | grep dontstarve`
    if [[ "$result" != "" ]]
    then
          rs=$(kill -9 ${item[0]}) 
    fi
done
