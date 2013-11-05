#!/usr/bin/env python

import sys
import json

for line in sys.stdin:
    # remove leading and trailing whitespace
    line = line.strip()
    json_data = json.loads(line)
    
    # get account actions as part of the session
    actions = ["updatePaymentInfo", "updatePassword", "parentalControls"]
    if 'Account' in json_data['type']:
        if 'subAction' in json_data['payload']:
            try:
                for action in actions:
                    if action in json_data['payload']['subAction']:
                        user = json_data['user']
                        session_id = json_data['sessionId']                
                        created_at = json_data['createdAt']                        
                        
                        key = str(user) + "," + session_id
                        values = created_at + "," + action
                  
                        print '%s\t%s' % (key, values)
                    
            except KeyError as e:
                pass
    
    # Add type VerifyPassword to account actions data
    if 'VerifyPassword' in json_data['type']:
        try:
            user = json_data['user']
            session_id = json_data['sessionId']                
            created_at = json_data['createdAt']
            
            key = str(user) + "," + session_id
            values = created_at + "," + "VerifyPassword"
                      
            print '%s\t%s' % (key, values)
                                
        except KeyError as e:
            pass

