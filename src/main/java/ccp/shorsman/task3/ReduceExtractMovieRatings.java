// ReduceExtractMovieRatings receives values rating and createdAt which we write to a SortedMap 
// and then just writes out the last value based on the last date.
package ccp.shorsman.task3;

import java.io.IOException;
import java.util.SortedMap;
import java.util.TreeMap;

import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Reducer;

import org.joda.time.DateTime;
import org.joda.time.format.DateTimeFormat;
import org.joda.time.format.DateTimeFormatter;

public class ReduceExtractMovieRatings extends Reducer<Text, Text, Text, Text> {

	@Override
	public void reduce(Text key, Iterable<Text> values, Context context)
			throws IOException, InterruptedException {

		SortedMap<DateTime, String> sortedRatings = new TreeMap<DateTime, String>();

		for (Text value : values) {

			String[] splitValues = value.toString().split(",");
			String createdAt = splitValues[0];
			String rating = splitValues[1];

			DateTimeFormatter fmt = DateTimeFormat.forPattern(
					"yyyy-MM-dd HH:mm:ss").withZoneUTC();
			DateTime currentDate = fmt.parseDateTime(createdAt);

			sortedRatings.put(currentDate, rating);
		}

		String lastRating = sortedRatings.get(sortedRatings.lastKey());

		context.write(key, new Text(lastRating.toString()));

	}
}

