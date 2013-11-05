// MapCreateSession extracts users, sessionIds, dates and actions 
package ccp.shorsman.task2;

import java.io.IOException;

import org.apache.hadoop.io.LongWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Mapper;
import org.json.simple.JSONObject;
import org.json.simple.JSONValue;

public class MapCreateSession extends Mapper<LongWritable, Text, Text, Text> {

	@Override
	public void map(LongWritable key, Text value, Context context)
			throws IOException, InterruptedException {

		String line = value.toString();

		JSONObject json = (JSONObject) JSONValue.parse(line);

		String action = (String) json.get("type");
		Long userId = (Long) json.get("user");

		if (action.toString().equalsIgnoreCase("Login")
				|| action.toString().equalsIgnoreCase("Logout")
				|| action.toString().equalsIgnoreCase("VerifyPassword")
				|| action.toString().equalsIgnoreCase("Queue")) {

			String sessionId = (String) json.get("sessionId");
			String createdAt = (String) json.get("createdAt");
			String newKey = sessionId + "\t" + userId;
			String newValue = createdAt + "\t" + action + "\t" + "0";

			context.write(new Text(newKey), new Text(newValue));

		} else {

			JSONObject payload = (JSONObject) json.get("payload");

			String movieId = (String) payload.get("itemId");

			if (movieId == null || movieId.trim().equals(""))
				movieId = "0";

			if (action.toString().equalsIgnoreCase("Play")) {

				action = "PlayMovie";

				if (movieId.contains("e")) {

					action = "PlayTV";
				}
			}

			String sessionId = (String) json.get("sessionId");
			String createdAt = (String) json.get("createdAt");

			String newKey = sessionId + "\t" + userId;
			String newValue = createdAt + "\t" + action + "\t" + movieId;

			context.write(new Text(newKey), new Text(newValue));
		}
	}
}