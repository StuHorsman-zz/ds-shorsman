#!/usr/bin/env python

import sys
import json

for line in sys.stdin:
    # remove leading and trailing whitespace
    line = line.strip()
    json_data = json.loads(line)
    
    # extract json home types and write csv row
    # to contain 5 recommended and 5 popular items
    if "Home" in json_data['type']:
        if json_data['payload']:
            try:
                created_at = json_data['createdAt']
                session_id = json_data['sessionId']
                user = json_data['user']
                payload_popular_item_0 = json_data['payload']['popularItems'][0]
                payload_popular_item_1 = json_data['payload']['popularItems'][1]
                payload_popular_item_2 = json_data['payload']['popularItems'][2]
                payload_popular_item_3 = json_data['payload']['popularItems'][3]
                payload_popular_item_4 = json_data['payload']['popularItems'][4]
                payload_recommended_item_0 = json_data['payload']['recommendedItems'][0]
                payload_recommended_item_1 = json_data['payload']['recommendedItems'][1]
                payload_recommended_item_2 = json_data['payload']['recommendedItems'][2]
                payload_recommended_item_3 = json_data['payload']['recommendedItems'][3]
                payload_recommended_item_4 = json_data['payload']['recommendedItems'][4]
                    
                # handle recentItem, can sometimes contain an empty list
                payload_recent_item = 0
                if len(json_data['payload']['recentItem']) > 0:
                    payload_recent_item = json_data['payload']['recentItem'][0]
      
                # TODO consider whether ref_id or auth or needed 
                # ref_id = json_data['refId']
                # auth = json_data['auth']
                # ref_id and auth don't appear in popular type records
                    
                key = created_at + "\t" + session_id + "\t" + str(user)
                values = payload_popular_item_0 + "\t" + \
                payload_popular_item_1 + "\t" + \
                payload_popular_item_2 + "\t" + \
                payload_popular_item_3 + "\t" + \
                payload_popular_item_4 + "\t" + \
                payload_recommended_item_0 + "\t" + \
                payload_recommended_item_1 + "\t" + \
                payload_recommended_item_2 + "\t" + \
                payload_recommended_item_3 + "\t" + \
                payload_recommended_item_4 + "\t" + \
                str(payload_recent_item) + "\t"

                print '%s\t%s' % (key, values)
                    
            except KeyError as e:
                pass


