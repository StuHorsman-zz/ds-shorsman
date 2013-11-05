// MapExtractMovieRatings for extracting movie ratings and reviews.  A rating for a TV episode
// is assumed to be a rating for the entire series.
package ccp.shorsman.task3;

import java.io.IOException;

import org.apache.hadoop.io.LongWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Mapper;

import org.json.simple.JSONObject;
import org.json.simple.JSONValue;

public class MapExtractMovieRatings extends
		Mapper<LongWritable, Text, Text, Text> {

	@Override
	public void map(LongWritable key, Text value, Context context)
			throws IOException, InterruptedException {

		String line = value.toString();

		JSONObject json = (JSONObject) JSONValue.parse(line);

		String action = (String) json.get("type");

		if (action.toString().equalsIgnoreCase("Rate")
				|| action.toString().equalsIgnoreCase("WriteReview")) {

			Long userId = (Long) json.get("user");
			JSONObject payload = (JSONObject) json.get("payload");
			if (payload == null)
				return;

			String movieId = (String) payload.get("itemId");
			String createdAt = (String) json.get("createdAt");

			if (movieId == null || movieId.trim().equals(""))
				return;
			
			if (movieId.contains("e")) {

				int index = movieId.indexOf("e");
				movieId = movieId.substring(0, index);
			}

			Number rating = (Number) payload.get("rating");

			if (rating == null || rating.toString().trim().equals(""))
				return;

			String newKey = userId.toString() + "," + movieId; 
			
			String newValue = createdAt + "," + rating.toString();

			context.write(new Text(newKey), new Text(newValue));

		}

	}
}