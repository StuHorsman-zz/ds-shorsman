#!/usr/bin/env python

import sys
import json

for line in sys.stdin:
    line = line.strip()
    json_data = json.loads(line)
    
    if 'Play' in json_data['type']:
        if json_data['payload']['itemId']:
            try:
                user = json_data['user']
                movie_id = json_data['payload']['itemId']
                                
                # Concatentate the key and separate by ','
                key = str(user) + ',' + str(movie_id)
                
                print '%s\t%d' % (key, 1)
                
            except KeyError as e:
                pass

