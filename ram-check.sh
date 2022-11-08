#!/bin/bash

date_today=`date`
mem_info=`awk '$3=="kB"{$2=$2/1048576;$3="GB"} 1' /proc/meminfo | column -t | grep "MemAvailable"`

available_memory=`echo $mem_info | cut -c14-18`
int_available_memory=(${available_memory//./ }[0])

if [ $int_available_memory -lt 2 ]
then
    XDG_RUNTIME_DIR=/run/user/$(id -u) notify-send -u critical "Low memory" "only $(echo $available_memory | tr -s " ") GB available!"

    if [ $int_available_memory -lt 1 ]
    then
        echo "$date_today MemAvailable: $(echo $available_memory | tr -s " ") GB - VERY LOW MEMORY (killing chrome, gitkraken and spotify)" >> ~/Desktop/ram.txt
        pkill chrome
        pkill gitkraken
        pkill spotify
    else
        echo "$date_today MemAvailable: $(echo $available_memory | tr -s " ") GB - LOW MEMORY" >> ~/Desktop/ram.txt
    fi
fi