"""

    usage: merge_csv.py {2+ csv-files} > out.csv
    Note:
        1. Will skip lines with dates that are not common to all inputs

"""


import sys
import csv

inputs = sys.argv[1:]

# First determine the field names from the top line of each input file
# Comment 1 below
fieldnames = []
for filename in inputs:
  with open(filename, "r") as f_in:
    reader = csv.reader(f_in)
    headers = next(reader)
    for h in headers:
      if h not in fieldnames:
        fieldnames.append(h)

dates = {}
dates_occ = {}

# read and output the merge data
writer = csv.DictWriter(sys.stdout, fieldnames=fieldnames)
writer.writeheader()
for filename in inputs:
    with open(filename, "r") as f_in:
        reader = csv.DictReader(f_in)  # Uses the field names in this file
        for line in reader:
            
            date = line['date']
            
            if date in dates_occ:
                dates_occ[date] += 1
            else:
                dates_occ[date] = 1
            
            # merge the data into "line"
            if date in dates:
                prev_data = dates[date]
                for key in prev_data:                    
                    if key != 'date':
                            line[key] = prev_data[key]
            
            dates[date] = line
for date in sorted(dates):
    if dates_occ[date] <= len(inputs):
        line = dates[date]
        writer.writerow(line)

