#!/bin/bash

s=$1
trc=$2


while true

do

        echo delayed

	# run in background
	/opt/vdbench/vdbench -f vdb_hack.$s &

	for ((i=0; i< $s; i++))
	do
	    sleep 1
	    d1=`date +"%d/%m %H:%M:%S.0"`
	    str="$d1 0x1234567:_label_vdb_hack:1: is_on for $s sec"
	    echo $str >> $trc
	done

	echo Not delayed
	sleep 10

done

