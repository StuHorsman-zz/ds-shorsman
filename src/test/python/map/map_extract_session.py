#!/usr/bin/env python

import sys
import json

for line in sys.stdin:
    line = line.strip()
    json_data = json.loads(line)
    
    try:
        created_at = json_data['createdAt']
        session_id = json_data['sessionId']
        user = json_data['user']
        
        # Concatentate the key and separate by ','
        key = str(user) + ',' + session_id
        values = created_at + ',' + json_data['type']
        
        print '%s\t%s' % (key, values)
        
    except KeyError as e:
        pass

