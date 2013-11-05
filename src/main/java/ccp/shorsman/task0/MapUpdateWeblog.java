//  MapUpdateWeblog cleans the Cloudera Movie logs and sets all JSON keys to the same value.
//  Sets all dates to UTC.
package ccp.shorsman.task0;

import java.io.IOException;

import org.apache.hadoop.io.LongWritable;
import org.apache.hadoop.io.NullWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Mapper;

import org.joda.time.DateTime;
import org.joda.time.format.DateTimeFormat;
import org.joda.time.format.DateTimeFormatter;
import org.joda.time.format.ISODateTimeFormat;

import org.json.simple.JSONObject;
import org.json.simple.JSONValue;

public class MapUpdateWeblog extends
		Mapper<LongWritable, Text, Text, NullWritable> {

	@Override
	public void map(LongWritable key, Text value, Context context)
			throws IOException, InterruptedException {

		String line = value.toString();

		line = line.trim();
		line = line.replace("\"itemId\"\"", "\"itemId\"");
		line = line.replace("\"created_at\"", "\"createdAt\"");
		line = line.replace("\"session_id\"", "\"sessionId\"");
		line = line.replace("\"popular\"", "\"popularItems\"");
		line = line.replace("\"popularItem\"", "\"popularItems\"");
		line = line.replace("\"recommended\"", "\"recommendedItems\"");
		line = line.replace("\"recommendedItem\"", "\"recommendedItems\"");
		line = line.replace("\"recs\"", "\"recommendedItems\"");
		line = line.replace("\"recent\"", "\"recentItem\"");
		line = line.replace("\"item_id\"", "\"itemId\"");

		JSONObject json = (JSONObject) JSONValue.parse(line);
		String createdAt = (String) json.get("createdAt");

		DateTimeFormatter parser = ISODateTimeFormat.dateTimeParser();
		DateTime dateTime = parser.parseDateTime(createdAt);

		DateTimeFormatter fmt = DateTimeFormat
				.forPattern("yyyy-MM-dd HH:mm:ss").withZoneUTC();

		String newCreatedAt = fmt.print(dateTime);

		line = line.replace(createdAt, newCreatedAt);

		context.write(new Text(line), NullWritable.get());

	}
}