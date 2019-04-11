#!/usr/bin/env python
import re
import csv
import sys
import os
import datetime


dir=sys.argv[1]
for file_name in sorted(os.listdir(dir)):
    dict = {}
    file_path = os.path.join(dir, file_name)
    with open(file_path,'r') as f:
        for line in f:
            # parse ini files (screen 5)
            if re.search("SockIP", line):
                sock_ip = line.split(":",4)[3].split(" ",2)[1]
            if re.search("send-latency.*avg/stddev",line):
                value = line.split(":",7)[7].split("/",1)[0]
                key = "send_latency_" + sock_ip
                dict[key] = value
            if re.search("recv-latency.*avg/stddev",line):
                value = line.split(":",7)[7].split("/",1)[0]
                key = "recv_latency_" + sock_ip
                dict[key] = value
            # parse tgt files (screen 2)
            if re.search("Ip addr", line):
                latency_key = "Latency_" + line.split(":",2)[1].split(" ",2)[0]
            if re.search("Latency:.*Min",line):
                value = line.split(":",3)[3].split(" ",2)[0]
                dict[latency_key] = value
    
    bExist=os.path.isfile('./sdbg.csv')
    with open('sdbg.csv','a') as out_file:
        if not bExist:
            out_file.write("date,")
            [out_file.write('{},'.format(key)) for key in dict.keys()]
        date = file_name.replace("_","/",1).replace("_"," ").replace("ini","").replace("tgt","")
        out_file.write("\n" + date + ",")
        [out_file.write('{},'.format(value)) for value in dict.values()]

