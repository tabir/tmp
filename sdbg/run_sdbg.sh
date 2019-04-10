#!/bin/bash

for i in {1..25}; do
    start_date_millis=`date +%s%N | cut -b1-13`
    /opt/emc/scaleio/sds/diag/sdbg sdbg_dump_5.txt > output/$(date +"%d_%m_%H:%M:%S")
    end_date_millis=`date +%s%N | cut -b1-13`
    sleep_time=$(( 1000 - $(( $end_date_millis - $start_date_millis )) ))
    if [ $sleep_time -gt 0 ]
    then
        #echo "0.$(( 1000 - $(( $end_date_millis - $start_date_millis )) ))"
        sleep 0.$(( 1000 - $(( $end_date_millis - $start_date_millis )) ))
    fi
    #./extract_sdbg.py sdbg_out_5.txt
    #sleep 1
    #rm sdbg_out_5.txt
done

