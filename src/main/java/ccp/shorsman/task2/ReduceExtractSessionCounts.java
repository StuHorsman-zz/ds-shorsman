// ReduceExtractSessionCounts creates a csv for input into the Cloudera ML jobs.  Each column
// represents a duration for each action during a session.  The last two columns are a count of 
// how many unique items were watched during the session (using java.util.Set). 
package ccp.shorsman.task2;

import java.io.IOException;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;

import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Reducer;
import org.joda.time.DateTime;
import org.joda.time.Seconds;
import org.joda.time.format.DateTimeFormat;
import org.joda.time.format.DateTimeFormatter;

public class ReduceExtractSessionCounts extends Reducer<Text, Text, Text, Text> {

	@Override
	public void reduce(Text key, Iterable<Text> values, Context context)
			throws IOException, InterruptedException {

		int[] sessionArray;
		
		Set<String> uniqueMovies = new HashSet<String>();
		Set<String> uniqueTvEpisodes = new HashSet<String>();

		sessionArray = new int[16];

		// Go through all values to and group together like actions
		for (Text value : values) {
			// Split the value on between action and date
			String[] valuesList = value.toString().split(",");
			String action = valuesList[0];
			String createdAt = valuesList[1];
			int actionDuration = Integer.parseInt(valuesList[2]);
			String itemId = valuesList[3];

			// For clustering we'll group together some events based on
			// likeness:
			// Login & Logout
			if (action.toString().equalsIgnoreCase("Login"))
				sessionArray[0] += actionDuration;
			if (action.toString().equalsIgnoreCase("Logout"))
				sessionArray[1] += actionDuration;

			// Account & VerifyPassword (group)
			if (action.toString().equalsIgnoreCase("Account"))
				sessionArray[2] += actionDuration;
			if (action.toString().equalsIgnoreCase("VerifyPassword"))
				sessionArray[2] += actionDuration;

			// WriteReview & Rate (group)
			if (action.toString().equalsIgnoreCase("Rate"))
				sessionArray[3] += actionDuration;
			if (action.toString().equalsIgnoreCase("WriteReview"))
				sessionArray[3] += actionDuration;

			// Queue, AddToQueue, ItemPage must be when a user adds a movie to
			// be watched (group)
			if (action.toString().equalsIgnoreCase("AddToQueue"))
				sessionArray[4] += actionDuration;
			if (action.toString().equalsIgnoreCase("Queue"))
				sessionArray[4] += actionDuration;
			if (action.toString().equalsIgnoreCase("ItemPage"))
				sessionArray[4] += actionDuration;

			// Advance, Position and Resume (all have a marker so group)
			// Are there lots of session which resume in the middle of a film?
			if (action.toString().equalsIgnoreCase("Advance"))
				sessionArray[5] += actionDuration;
			if (action.toString().equalsIgnoreCase("Position"))
				sessionArray[5] += actionDuration;
			if (action.toString().equalsIgnoreCase("Resume"))
				sessionArray[5] += actionDuration;

			// Home page
			if (action.toString().equalsIgnoreCase("Home"))
				sessionArray[6] += actionDuration;

			// Hover action
			if (action.toString().equalsIgnoreCase("Hover"))
				sessionArray[7] += actionDuration;

			// Stop & Pause represent some sort of interruption
			if (action.toString().equalsIgnoreCase("Pause"))
				sessionArray[8] += actionDuration;
			if (action.toString().equalsIgnoreCase("Stop"))
				sessionArray[9] += actionDuration;

			// Recommendations
			if (action.toString().equalsIgnoreCase("Recommendations"))
				sessionArray[10] += actionDuration;

			// Search
			if (action.toString().equalsIgnoreCase("Search"))
				sessionArray[11] += actionDuration;
			
			// Split Play between Movies and TV
			// Add a count of how many movies and TV was watched
			if (action.toString().equalsIgnoreCase("PlayTV")) {
				sessionArray[12] += actionDuration;
				
				uniqueTvEpisodes.add(itemId);
			}
				
			
			if (action.toString().equalsIgnoreCase("PlayMovie")) {
				sessionArray[14] += actionDuration;
				
				uniqueMovies.add(itemId);
			}

		}
		
		sessionArray[13] = uniqueTvEpisodes.size();
		sessionArray[15] = uniqueMovies.size();
		
		StringBuffer newValue = new StringBuffer("");
		for (int i = 0; i < sessionArray.length; i++) {
			if (i > 0)
				newValue.append(",");

			newValue.append(sessionArray[i]);

		}
		context.write(key, new Text(newValue.toString()));
	}
}
