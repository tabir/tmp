#!/bin/bash

for i in {1..450}; do
    start_date_millis=`date +%s%N | cut -b1-13`
    /opt/emc/scaleio/sds/diag/sdbg sdbg_dump.txt > output/$(date +"%d_%m_%H:%M:%S")
    end_date_millis=`date +%s%N | cut -b1-13`
    sleep_time=$(( 2000 - $(( $end_date_millis - $start_date_millis )) ))
    if [ $sleep_time -gt 0 ]; then
        sleep $(( $sleep_time / 2000)).$sleep_time
    fi
done

