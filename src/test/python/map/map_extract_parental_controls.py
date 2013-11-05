#!/usr/bin/env python

import sys
import json

for line in sys.stdin:
    # remove leading and trailing whitespace
    line = line.strip()
    json_data = json.loads(line)
    
    # extract json account types and write csv row
    # to contain old and new values for parental
    # controls
    if 'Account' in json_data['type']:
        if 'subAction' in json_data['payload']:
            if 'parentalControls' in json_data['payload']['subAction']:
                try:
                    created_at = json_data['createdAt']
                    session_id = json_data['sessionId']
                    user = json_data['user']
                    payload_old = json_data['payload']['old']
                    payload_new = json_data['payload']['new']
                   
                    if 'kid' in json_data['payload']['new']:
                        user_type = 1
                    else:
                        user_type = 0
                    
                    key = created_at + "\t" + session_id + "\t" + str(user)
                    values = payload_old + "\t" + payload_new + "\t" + str(user_type)
                  
                    print '%s\t%s' % (key, values)
                    
                except KeyError as e:
                    pass
