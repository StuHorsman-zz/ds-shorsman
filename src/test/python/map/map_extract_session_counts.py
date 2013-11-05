#!/usr/bin/env python

import sys
import json

for line in sys.stdin:
    line = line.strip()
    json_data = json.loads(line)
    
    try:
        # Set key to session_id, value to type
        session_id = json_data['sessionId']
        action = json_data['type']
           
        print '%s\t%s' % (session_id, action)
        
    except KeyError as e:
        pass