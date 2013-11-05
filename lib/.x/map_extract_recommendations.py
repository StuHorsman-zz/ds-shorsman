#!/usr/bin/env python

import sys
import json

for line in sys.stdin:
    # remove leading and trailing whitespace
    line = line.strip()
    json_data = json.loads(line)
    
    # extract movie actions into one file
    # stop, start, pause etc
    if 'Recommendations' in json_data['type']:
        if 'recommendedItems' in json_data['payload']:
            try:
            
                # set the key
                created_at = json_data['createdAt']
                session_id = json_data['sessionId']
                user = json_data['user']
                
                values = ""
                
                # loop round and build the values
                for i in range(25):
        
                    # first val i = 0
                    if (i == 0):
                        values = json_data['payload']['recommendedItems'][i] + "\t"
                    
                    values = values + json_data['payload']['recommendedItems'][i] + "\t"
                    
                    # last val i = 24
                    if (i == 24):
                        values = values + json_data['payload']['recommendedItems'][i]
                            
                key = created_at + "\t" + session_id + "\t" + str(user)
                              
                print '%s\t%s' % (key, values)
                        
            except KeyError as e:
                pass

