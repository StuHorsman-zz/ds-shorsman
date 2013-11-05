#!/usr/bin/env python

import sys
import json

for line in sys.stdin:
    # remove leading and trailing whitespace
    line = line.strip()
    json_data = json.loads(line)
    
    # Get login and logoff actions
    actions = ["Login", "Logout"]
    for action in actions:
        if action in json_data['type']:
            try:
                created_at = json_data['createdAt']
                session_id = json_data['sessionId']
                user = json_data['user']
                type = json_data['type']
                  
                key = created_at + "\t" + session_id + "\t" + str(user)
                values = type
              
                print '%s\t%s' % (key, values)
                    
            except KeyError as e:
                pass


