#!/usr/bin/env python
import re
import csv
import sys
import os
import datetime

keys = []
with open('diag.txt','r') as diag:
    for line in diag:
        keys.append(line.strip())

dir=sys.argv[1]
prev_dict = dict.fromkeys(keys, 0)
for file_name in sorted(os.listdir(dir)):
    dict = {}
    file_path = os.path.join(dir, file_name)
    with open(file_path,'r') as f:
        for line in f:
            if re.search(":",line):
                key = line.split(":",2)[1]
                if key in keys:
                    value = line.split(" ",2)[1]
                    dict[key] = int(value) - prev_dict[key]
                    prev_dict[key] = int(value)
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
        date = file_name.replace("_","/",1).replace("_"," ")
        out_file.write("\n" + date + ",")
        [out_file.write('{},'.format(value)) for value in dict.values()]

