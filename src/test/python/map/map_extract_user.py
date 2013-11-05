#!/usr/bin/env python

import sys
import json

for line in sys.stdin:
    # remove leading and trailing whitespace
    line = line.strip()
    json_data = json.loads(line)
    
    # extract user id's as key
    # and assign default adult 0 to user
    try:
        if json_data['user']:
            key = json_data['user']
            
            print '%s\t%s' % (key, 0)
    except KeyError as e:
        print e

