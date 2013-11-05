#!/usr/bin/env python

import sys
import json

for line in sys.stdin:
    line = line.strip()
    json_data = json.loads(line)
    
    if 'Play' in json_data['type']:
        if json_data['payload']['itemId']:
            try:
                created_at = json_data['createdAt']
                session_id = json_data['sessionId']
                user = json_data['user']
                movie_id = json_data['payload']['itemId']
                action = json_data['type']
                
                # Concatentate the key and separate by ','
                key = str(user) + ',' + session_id
                values = created_at + ',' + action + ',' + movie_id
                
                print '%s\t%s' % (key, values)
                
            except KeyError as e:
                pass

