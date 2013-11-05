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
    if 'WriteReview' in json_data['type']:
        if 'itemId' in json_data['payload']:
            try:
                created_at = json_data['createdAt']
                session_id = json_data['sessionId']
                user = json_data['user']
                item_id = json_data['payload']['itemId']
                rating = json_data['payload']['rating']
                length = json_data['payload']['length']
               
                key = created_at + "\t" + session_id + "\t" + str(user)
                values = item_id + "\t" + str(rating) + str(length)
              
                print '%s\t%s' % (key, values)
                
            except KeyError as e:
                pass

