#!/bin/bash
for mrjob in `ls -1 05_runmr_extract_*.sh`
do
	./$mrjob
done
