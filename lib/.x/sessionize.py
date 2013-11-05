#! /usr/bin/env jython
import sys
sys.path += ['/usr/lib/jython2.5.3/Lib', '__classpath__', '__pyclasspath__/', '/usr/lib/jython2.5.3/Lib/site-packages']

import time
import random

activity_hash = {"rate_movie":1, "completed_movie":2, "paused_movie":3,\
	    "started_movie":4,"browsed_movie":5, "list_movie":6,\
	    "search_movie":7, "login":8, "logout":9}
sessionized_output = "sessionId:int, time:chararray, custId:int, duration_session, num_rated:int,"+\
		     "duration_rated:double, num_completed:int, duration_completed:double,"+\
		     "time_to_first_start:int, num_started:int,"+\
		     "num_browsed:int, duration_browsed, num_listed:int,duration_listed:int,"+\
		     "num_incomplete:int, num_searched"

#sessionized_output = "sessionId:int, custId:int,time:chararray, clickcount:int"

@outputSchema("ts:int")
def to_unix_timestamp(tstring):
	if tstring:
		return unix_timestamp(tstring)


def unix_timestamp(tstring):
	#print "tstring", tstring
	d = time.strptime(tstring, "%Y-%m-%d")
	return int(time.mktime(d))

def hi_res_unix_timestamp(tstring):
	d = time.strptime(tstring, "%Y-%m-%d:%H:%M:%S")
	return int(time.mktime(d))
	
@outputSchema(sessionized_output)
def accumulate(timeout, action_tuple):
	#print "len action_tuple:", len(action_tuple)
	#print action_tuple
	session_bag = []
	session_hash = {}
	try:
		last_timestamp = hi_res_unix_timestamp(action_tuple[0][4])
	except:
		#print "no valid timestamp"
		return None
	cust_id = action_tuple[0][1]
	session_timestamp = last_timestamp
	session_id = None
	session_id = random.randint(1,100000000)
	for grouped_tuple in action_tuple:
		#print grouped_tuple
		timestamp = hi_res_unix_timestamp(grouped_tuple[4])
		timedelta = int(timestamp)-last_timestamp
		activity = grouped_tuple[6]
		#print timedelta, last_timestamp, timestamp


		#session_id = int(str(session_timestamp/100)+str(grouped_tuple[0]))

		expires = int(timeout)*60
		if activity == activity_hash["started_movie"] or activity == activity_hash["paused_movie"]:
			expires = 60*60*4
		if timedelta <= expires:
			#print "existing session"
			if session_id not in session_hash:
				session_hash[session_id] = []
			session_hash[session_id].append(grouped_tuple)
		else:
			#print "new session"
			session_timestamp = timestamp
			#session_id = int(str(session_timestamp/100)+str(grouped_tuple[0]))
			session_id = random.randint(1,100000000)
			session_hash[session_id] = [grouped_tuple]
		#print "timestamp advances from", last_timestamp
		#print "to", timestamp
		last_timestamp = timestamp
	#print "there are ", len(session_hash), "sessions in ", len(action_tuple), " tuples"
	
	for session_id in session_hash:
		#print len(session_hash[session_id]), " clicks this session"
		session_hash[session_id].sort(key=lambda x:hi_res_unix_timestamp(x[4]))
		click_analysis = get_click_analysis(session_id, session_hash)
		#print "click_analysis", click_analysis
		session_bag.append(click_analysis)
	
	#print "returning customer", cust_id
	return session_bag

	
def get_activity(clickstream, act):
	act_index = 6
	return filter(lambda x:x[act_index] == activity_hash[act], clickstream)

def get_duration(clickstream, act=None):
	time_index = 4
	act_index = 6
	times = map(lambda x:hi_res_unix_timestamp(x[time_index]), clickstream)
	activities = map(lambda x:int(x[act_index]), clickstream)
	if len(times) == 0:
		return 0
	else:
		duration = 0
		if act:
			for i in range(len(activities)-1):
				if activities[i] == activity_hash[act]:
					timedelta = times[i+1]-times[i]
					duration += timedelta
		else:
			duration = max(times) - min(times)
		return duration

def get_completed_duration(clickstream):
	time_index = 4
	act_index = 6
	movie_index = 2
	incompletes = 0
	times = map(lambda x:hi_res_unix_timestamp(x[time_index]), clickstream)
	activities = map(lambda x:int(x[act_index]), clickstream)
	try:
		movie_ids = map(lambda x:int(x[movie_index]), clickstream)
	except:
		return 0
	
	if len(times) == 0:
		return 0
	else:
		duration = 0
		for i in range(len(activities)):
			if activities[i] == activity_hash["started_movie"]:
				started = True
				movie_id = movie_ids[i]
				for j in range(i+1, len(activities)):
					state = activities[j]
					if state == activity_hash["completed_movie"] and movie_ids[j] == movie_id:
						timedelta = times[j] - times[i]
						duration += timedelta
	return duration

def get_first_start(clickstream):
	time_index = 4
	act_index = 6
	times = map(lambda x:hi_res_unix_timestamp(x[time_index]), clickstream)
	activities = map(lambda x:int(x[act_index]), clickstream)
	duration = 0
	start_time = times[0]
	for i in range(len(activities)):
		if activities[i] == activity_hash["started_movie"]:
			duration = times[i] - start_time
			break
	return duration
	
def get_incomplete_movies(clickstream):
	time_index = 4
	act_index = 6
	movie_index = 2
	incompletes = 0
	times = map(lambda x:hi_res_unix_timestamp(x[time_index]), clickstream)
	activities = map(lambda x:int(x[act_index]), clickstream)
	try:
		movie_ids = map(lambda x:int(x[movie_index]), clickstream)
	except:
		return 0
	for i in range(len(activities)):
		if activities[i] == activity_hash["paused_movie"]:
			paused = True
			for j in range(i+1, len(activities)):
				state = activities[j]
				if state == activity_hash["started_movie"] or state == activity_hash["completed_movie"]:
					if movie_ids[i] == movie_ids[j]:
						paused = False
			if paused:
				incompletes += 1
	return incompletes

def get_click_analysis(session, session_hash):
	session_id = session_hash[session][0][0]
	cust_id = session_hash[session][0][1]
	ts = session_hash[session][0][2]
	duration = get_duration(session_hash[session])
	num_rate_movie = len(get_activity(session_hash[session], "rate_movie"))
	rate_movie_duration = get_duration(session_hash[session], "rate_movie")
	num_completed_movie = len(get_activity(session_hash[session], "completed_movie"))
	#FIX ME
	completed_movie_duration = get_completed_duration(session_hash[session])
	
	time_to_first_start = get_first_start(session_hash[session])
	
	num_started_movie = len(get_activity(session_hash[session], "started_movie"))
	num_browsed_movie = len(get_activity(session_hash[session], "browsed_movie"))
	browsed_movie_duration = get_duration(session_hash[session], "browsed_movie")
	num_listed = len(get_activity(session_hash[session], "list_movie"))
	duration_listed = get_duration(session_hash[session], "list_movie")
	num_incomplete = get_incomplete_movies(session_hash[session])
	num_searched_movie = len(get_activity(session_hash[session], "search_movie"))
	num_logout = len(get_activity(session_hash[session], "logout"))
	click_analysis = (session, ts, cust_id, duration, num_rate_movie, rate_movie_duration,\
			  num_completed_movie, completed_movie_duration,time_to_first_start, \
			  num_started_movie,num_browsed_movie,browsed_movie_duration,\
			  num_listed, duration_listed, num_incomplete, num_searched_movie)

	#print "analysis for this session:", click_analysis
	return click_analysis
