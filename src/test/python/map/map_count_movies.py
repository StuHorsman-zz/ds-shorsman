#!/usr/bin/env python

import sys
import json

for line in sys.stdin:
    line = line.strip()
    json_data = json.loads(line)
    
    # ignore Account, Login, Logoff
    ignore_types = ['Account', 'Login', 'Logoff', 'VerifyPassword', 'Queue']
    for ignore in ignore_types:
        if ignore in json_data['type']:
            break
    
    # most types carry itemId in payload like:
    # Play, Hover, Advance, Stop, Resume, AddToQueue, ItemPage,
    # Pause
    gen_types = ['Play', 'Hover', 'Advance', 'Stop', 'Resume', 'ItemPage','Pause', 
                 'ItemPage', 'Position', 'WriteReview', 'Rate']
    
    for gen in gen_types:
        if gen in json_data['type']: 
                if 'itemId' in json_data['payload']:
                    key = json_data['payload']['itemId']
                    print '%s\t%s' % (key, 1)
                    break

        
    if 'Home' in json_data['type']:
        if json_data['payload']:
            try:
                for i in range(5):
                    key = json_data['payload']['popularItems'][i]
                    print '%s\t%s' % (key, 1)
                
                for i in range(5):
                    key = json_data['payload']['recommendedItems'][i]
                    print '%s\t%s' % (key, 1)
            except KeyError as e:
                pass
            
    if 'Search' in json_data['type']:
        if 'results' in json_data['payload']:
            try:
                for i in range(20):
                    key = json_data['payload']['results'][i]
                    print '%s\t%s' % (key, 1)
            except KeyError as e:
                pass
            
    if 'Recommendations' in json_data['type']:
        if 'recommendedItems' in json_data['payload']:
            try:
                for i in range(25):
                    key = json_data['payload']['results'][i]
                    print '%s\t%s' % (key, 1)
            except KeyError as e:
                pass
    
    
