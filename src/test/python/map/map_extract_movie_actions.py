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
                try:
                    created_at = json_data['createdAt']
                    session_id = json_data['sessionId']
                    user = json_data['user']
                                        
                    # handle the situation where payload is empty
                    movie_id = 0
                    #payload_marker = 0
                    
                    if len(json_data['payload']['itemId']) > 0:
                        movie_id = json_data['payload']['itemId']
                        #payload_marker = json_data['payload']['marker']
                    
                    key = str(user) + "," + session_id
                    values = created_at + "," + action + "," + movie_id
        
                    print '%s\t%s' % (key, values)
                
                except KeyError as e:
                    pass

