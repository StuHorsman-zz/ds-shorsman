#!/bin/bash

for type in AddToQueue Advance Home Hover ItemPage Login Logout Pause Play Position Queue Rate Recommendations Resume Search Stop VerifyPassword WriteReview
do
	lower_type=`echo $type | tr '[A-Z]' '[a-z]'`
	cp map_extract_account.py map_extract_${lower_type}.py
	cat map_extract_account.py | sed s/Account/${type}/ > map_extract_${lower_type}.py
done
