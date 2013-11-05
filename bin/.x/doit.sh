#!/bin/bash

for type in AddToQueue Advance Home Hover ItemPage Login Logout Pause Play Position Queue Rate Recommendations Resume Search Stop VerifyPassword WriteReview
do
	lower_type=`echo $type | tr '[A-Z]' '[a-z]'`
	cp 05_runmr_extract_account.sh 05_runmr_extract_${type}.sh
	cat 05_runmr_extract_account.sh | sed s/account/${lower_type}/ > 05_runmr_extract_${type}.sh
done
