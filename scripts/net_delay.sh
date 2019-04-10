#!/bin/bash

d=$1
s=$2
trc=$3


while true

do
	tc qdisc add dev enp6s0f1 root netem delay $d
        tc qdisc add dev enp131s0f1 root netem delay $d

        echo delayed

	for ((i=1; i< $s; i++))
	do
	    sleep 1

	    d1=`date +"%d/%m %H:%M:%S.0"`
	    str="$d1 0x1234567:label_tc_delay:1: delay_is_on for $d"
	    echo $str >> $trc
	done

	#sleep $(( ( RANDOM % 30 )  + 1 ))

	tc qdisc delete dev enp6s0f1 root netem delay $d
        tc qdisc delete dev enp131s0f1 root netem delay $d

	echo Not delayed
	sleep 10
done

