// MapCreateParentalControls extracts parental control information
package ccp.shorsman.task1;

import java.io.IOException;

import org.apache.hadoop.io.LongWritable;
import org.apache.hadoop.io.NullWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Mapper;
import org.json.simple.JSONObject;
import org.json.simple.JSONValue;

public class MapCreateParentalControls extends
		Mapper<LongWritable, Text, Text, NullWritable> {

	@Override
	public void map(LongWritable key, Text value, Context context)
			throws IOException, InterruptedException {

		String line = value.toString();

		JSONObject json = (JSONObject) JSONValue.parse(line);

		String action = (String) json.get("type");

		if (action == null || action.trim().equals(""))
			return;

		if (action.toString().equalsIgnoreCase("Account")) {
			JSONObject payload = (JSONObject) json.get("payload");
			if (payload == null)
				return;
			
			String subaction = (String) payload.get("subAction");
			if (subaction == null || subaction.trim().equals(""))
				return;
			
			if (subaction.toString().equalsIgnoreCase("parentalControls")) {

				Long userId = (Long) json.get("user");
				String sessionId = (String) json.get("sessionId");
				String createdAt = (String) json.get("createdAt");
				String payloadOld = (String) payload.get("old");
				String payloadNew = (String) payload.get("new");

				String userType = "0";

				if (payloadNew.toString().equalsIgnoreCase("kid")) {
					userType = "1";
				}

				String newKey = createdAt + "\t" + sessionId + "\t"
						+ userId.toString() + "\t" + payloadOld + "\t"
						+ payloadNew + "\t" + userType;

				context.write(new Text(newKey), NullWritable.get());

				
			}

		}
	}
}