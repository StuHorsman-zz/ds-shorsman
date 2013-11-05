#!/usr/bin/env python

import sys
import json

for line in sys.stdin:
    # remove leading and trailing whitespace
    line = line.strip()
    json_data = json.loads(line)
    
    # extract web actions into one file
    # Hover, AddToQueue, ItemPage etc
    actions = ["Hover", "AddToQueue", "ItemPage"]
    for action in actions:
        if action in json_data['type']:
            try:
                created_at = json_data['createdAt']
                session_id = json_data['sessionId']
                user = json_data['user']
                item_id = json_data['payload']['itemId']
                                  
                key = created_at + "\t" + session_id + "\t" + str(user)
                values = item_id + "\t" + action
              
                print '%s\t%s' % (key, values)
                    
            except KeyError as e:
                pass
            
    if "Queue" in json_data['type']:
        try:
                created_at = json_data['createdAt']
                session_id = json_data['sessionId']
                user = json_data['user']
                
                key = created_at + "\t" + session_id + "\t" + str(user)
                values = "0" + "\t" + "Queue"
                
                print '%s\t%s' % (key, values)
                
        except KeyError as e:
                pass
                
            


