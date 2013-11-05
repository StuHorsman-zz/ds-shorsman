#!/usr/bin/env python

import sys
import json

for line in sys.stdin:
    # remove leading and trailing whitespace
    line = line.strip()
    jsonData = json.loads(line)
    
    # extract json account types and write csv row
    # to contain old and new values for parental
    # controls
    if ('Rate' in jsonData['type']) or ('WriteReview' in jsonData['type']):
        if 'itemId' in jsonData['payload']:
            try:
                createdAt = jsonData['createdAt']
                sessionId = jsonData['sessionId']
                user = jsonData['user']
                itemId = jsonData['payload']['itemId']
                rating = jsonData['payload']['rating']
                
                if "e" in itemId:
                    itemSplit = itemId.split("e")
                    itemId = itemSplit[0] 
               
                key = createdAt + "\t" + sessionId + "\t" + str(user)
                values = itemId + "\t" + str(rating)
              
                print '%s\t%s' % (key, values)
                
            except KeyError as e:
                pass

