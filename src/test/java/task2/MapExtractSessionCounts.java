package ccp.shorsman.task2;

import java.io.IOException;

import org.apache.hadoop.io.LongWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Mapper;

public class MapExtractSessionCounts extends
		Mapper<LongWritable, Text, Text, Text> {

	@Override
	public void map(LongWritable key, Text value, Context context)
			throws IOException, InterruptedException {

		// Input is data from CreateSessionDuration
		String line = value.toString();
		
		String[] entry = line.split("\t");
		
		String sessionId = entry[0];
		String userId = entry[1];
		String createdAt = entry[2];
		String action = entry[3];
		String movieId = entry[4];
		String duration = entry[5];
		

		/*JSONObject json = (JSONObject) JSONValue.parse(line);

		String action = (String) json.get("type");
		String sessionId = (String) json.get("sessionId");
		String createdAt = (String) json.get("createdAt");

		if (action == null || action.trim().equals(""))
			return;
		if (sessionId == null || sessionId.trim().equals(""))
			return;

		if (action.toString().equalsIgnoreCase("Play")) {
			// try {

			JSONObject payload = (JSONObject) json.get("payload");
			if (payload == null)
				return;

			String moimport org.json.simple.JSONObject;
import org.json.simple.JSONValue;vieId = (String) payload.get("itemId");

			if (movieId == null || movieId.trim().equals(""))
				return;

			action = "PlayMovie";

			if (movieId.contains("e")) {

				action = "PlayTV";
			}
		}
*/
		action = action + "," + createdAt + "," + duration;

		context.write(new Text(sessionId), new Text(action));

	}

}
