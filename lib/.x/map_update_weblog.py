#!/usr/bin/env python

import sys
import re
import json
import dateutil.parser

# input comes from STDIN (standard input)
for line in sys.stdin:
    # remove leading and trailing whitespace
    line = line.strip()
    # fix the dataset by updating keys
    line = re.sub("\"itemId\"\"", "\"itemId\"", line)
    line = re.sub("\"created_at\"", "\"createdAt\"", line)
    line = re.sub("\"session_id\"", "\"sessionId\"", line)
    line = re.sub("\"popular\"", "\"popularItems\"", line)
    line = re.sub("\"popularItem\"", "\"popularItems\"", line)
    line = re.sub("\"recommended\"", "\"recommendedItems\"", line)
    line = re.sub("\"recommendedItem\"", "\"recommendedItems\"", line)
    line = re.sub("\"recs\"", "\"recommendedItems\"", line)
    line = re.sub("\"recent\"", "\"recentItem\"", line)
    line = re.sub("\"item_id\"", "\"itemId\"", line)
    
    # fix the time value to make it uniform
    json_data = json.loads(line)
    json_time = str(json_data['createdAt'])

    d1 = dateutil.parser.parse(json_time)
    d2 = d1.astimezone(dateutil.tz.tzutc())
    d3 = str(d2)
    line = re.sub(json_time, d3, line)
    line = re.sub("\+00:00", "", line)

    print '%s' % (line)
