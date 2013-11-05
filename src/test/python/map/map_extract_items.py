#!/usr/bin/env python

import sys
import json

for line in sys.stdin:
    # remove leading and trailing whitespace
    line = line.strip()
    json_data = json.loads(line)
    
    # extract movie actions into one file
    # stop, start, pause etc
    actions = ["Advance", "Pause", "Stop", "Resume", "Position", "Play"]
    for action in actions:
        if action in json_data['type']:
            if json_data['payload']:
                if json_data['payload']['itemId']:
                    try:
                        user = json_data['user']
                                            
                        payload_item_id = json_data['payload']['itemId']
                            
                        key = str(user)
                        values = payload_item_id
            
                        print '%s\t%s' % (key, values)
                    
                    except KeyError as e:
                        pass

