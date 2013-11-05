package ccp.shorsman.task3;

import java.io.IOException;

import org.apache.hadoop.io.LongWritable;
import org.apache.hadoop.io.NullWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Mapper;
import org.json.simple.JSONObject;
import org.json.simple.JSONValue;

public class MapExtractMovieRatings extends
		Mapper<LongWritable, Text, Text, NullWritable> {

	@Override
	public void map(LongWritable key, Text value, Context context)
			throws IOException, InterruptedException {

		String line = value.toString();

		JSONObject json = (JSONObject) JSONValue.parse(line);

		String action = (String) json.get("type");

		if (action.toString().equalsIgnoreCase("Rate")
				|| action.toString().equalsIgnoreCase("WriteReview")) {

			Long user_id = (Long) json.get("user");
			JSONObject payload = (JSONObject) json.get("payload");
			if (payload == null)
				return;

			String movie_id = (String) payload.get("itemId");

			if (movie_id == null || movie_id.trim().equals(""))
				return;
			
			if (movie_id.contains("e")) {

				int index = movie_id.indexOf("e");
				movie_id = movie_id.substring(0, index + 1);
			}

			Number rating = (Number) payload.get("rating");

			if (rating == null || rating.toString().trim().equals(""))
				return;

			String newKey = user_id.toString() + "," + movie_id + ","
					+ rating.toString();

			context.write(new Text(newKey), NullWritable.get());

		}

	}
}