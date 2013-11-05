// ReduceCreateSessionDuration calculates session duration spent on each action
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

public class ReduceCreateSessionDuration extends Reducer<Text, Text, Text, Text> {

	@Override
	public void reduce(Text key, Iterable<Text> values, Context context)
			throws IOException, InterruptedException {


		SortedMap<String, String> sortedValues = new TreeMap<String, String>();

		for (Text value : values) {

			String[] splitValues = value.toString().split("\t");
			String createdAt = splitValues[0];

			sortedValues.put(createdAt, value.toString());
		}

		String previousLine = null;
		DateTime previousDate = null;

		for (Map.Entry<String, String> entry : sortedValues.entrySet()) {
			
			DateTimeFormatter fmt = DateTimeFormat.forPattern("yyyy-MM-dd HH:mm:ss").withZoneUTC();
			DateTime currentDate = fmt.parseDateTime(entry.getKey());
			
			if (previousLine == null) {		// Looking at the first entry
				previousLine = entry.getValue();
				previousDate = currentDate;
			} else {
				Seconds duration = Seconds.secondsBetween(previousDate, currentDate);
				
				context.write(key, new Text(previousLine + "\t" + duration.getSeconds()));
				
				previousLine = entry.getValue();
				previousDate = currentDate;
			}
		}
		
		// Write out the last line
		if (previousLine != null) {
			context.write(key, new Text(previousLine + "\t" + 0));
		}
	}
}

