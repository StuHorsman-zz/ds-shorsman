package ccp.shorsman.task2;

import java.io.IOException;
import java.util.Map;
import java.util.SortedMap;
import java.util.TreeMap;

import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Reducer;
import org.joda.time.DateTime;
import org.joda.time.Seconds;
import org.joda.time.format.DateTimeFormat;
import org.joda.time.format.DateTimeFormatter;

public class ReduceCreateSession extends Reducer<Text, Text, Text, Text> {

	@Override
	public void reduce(Text key, Iterable<Text> values, Context context)
			throws IOException, InterruptedException {

		DateTime firstDate = null;
		DateTime lastDate = null;
		// String movieId = null;

		SortedMap<String, String> sortedValues = new TreeMap<String, String>();

		for (Text value : values) {

			String[] splitValues = value.toString().split("\t");
			String createdAt = splitValues[0];

			sortedValues.put(createdAt, value.toString());
		}

		String currentMovieId = null;
		String currentTVId = null;

		for (Map.Entry<String, String> entry : sortedValues.entrySet()) {

			String[] splitValues = entry.toString().split("\t");
			String createdAt = splitValues[0];
			String action = splitValues[1];
			String movieId = splitValues[2];

			if (action.equalsIgnoreCase("PlayMovie")) {
				currentTVId = null;

				if (currentMovieId == null) {
					// Looking at the first PlayMovie after another action,
					// save the movie id out output the line
					currentMovieId = movieId;
					context.write(key, new Text(entry.getValue()));
				} else if (!movieId.equals(currentMovieId)) {
					// Movie id is different, so output the line
					currentMovieId = movieId;
					context.write(key, new Text(entry.getValue()));
				} else {
					// Movie id is the same - don't output the line
				}
			} else if (action.equalsIgnoreCase("PlayTV")) {
				currentMovieId = null;

				if (currentTVId == null) {
					// Looking at the first PlayMovie after another action,
					// save the movie id out output the line
					currentTVId = movieId;
					context.write(key, new Text(entry.getValue()));
				} else if (!movieId.equals(currentTVId)) {
					// Movie id is different, so output the line
					currentTVId = movieId;
					context.write(key, new Text(entry.getValue()));
				} else {
					// Movie id is the same - don't output the line
				}
			} else {
				currentMovieId = null;
				currentTVId = null;
				context.write(key, new Text(entry.getValue()));
			}

		}
	}

}

