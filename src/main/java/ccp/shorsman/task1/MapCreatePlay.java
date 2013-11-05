// MapCreatePlay mapper for CreatePlay
package ccp.shorsman.task1;

import java.io.IOException;

import org.apache.hadoop.io.LongWritable;
import org.apache.hadoop.io.NullWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Mapper;
import org.json.simple.JSONObject;
import org.json.simple.JSONValue;

public class MapCreatePlay extends
		Mapper<LongWritable, Text, Text, NullWritable> {

	@Override
	public void map(LongWritable key, Text value, Context context)
			throws IOException, InterruptedException {

		String line = value.toString();

		JSONObject json = (JSONObject) JSONValue.parse(line);

		String action = (String) json.get("type");

		if (action.toString().equalsIgnoreCase("Play")) {
			// try {
			Long userId = (Long) json.get("user");
			JSONObject payload = (JSONObject) json.get("payload");
			if (payload == null)
				return;

			String movieId = (String) payload.get("itemId");

			if (movieId == null || movieId.trim().equals(""))
				return;

			if (movieId.contains("e")) {

				int index = movieId.indexOf("e");
				movieId = movieId.substring(0, index + 1);
			}

			String sessionId = (String) json.get("sessionId");
			String createdAt = (String) json.get("createdAt");
			
			String newKey = userId.toString() + "\t" + sessionId + "\t"
					+ createdAt + "\t" + action + "\t" + movieId;

			context.write(new Text(newKey), NullWritable.get());

		}

	}
}