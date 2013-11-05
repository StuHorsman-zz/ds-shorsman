package ccp.shorsman.task1;

import java.io.IOException;

import org.apache.hadoop.io.LongWritable;
import org.apache.hadoop.io.NullWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Mapper;
import org.json.simple.JSONObject;
import org.json.simple.JSONValue;

public class MapCreatePlayWithoutTV extends
		Mapper<LongWritable, Text, Text, NullWritable> {

	@Override
	public void map(LongWritable key, Text value, Context context)
			throws IOException, InterruptedException {
		
		String line = value.toString();

        JSONObject json = (JSONObject) JSONValue.parse(line);
        
        String action = (String)json.get("type");
        
        if (action.toString().equalsIgnoreCase("Play")) {
        	//try {
        		Long user_id = (Long)json.get("user");
        		JSONObject payload = (JSONObject)json.get("payload");
        		if (payload == null) return;
        		
        		String movie_id = (String)payload.get("itemId");
                
        		if (movie_id == null || movie_id.trim().equals("")) return;
        		
        		String session_id = (String)json.get("sessionId");
        		String created_at = (String)json.get("createdAt");
                
        		String newKey = user_id.toString() + "\t" + session_id + "\t" + created_at + "\t" + action + "\t" + movie_id;
                
                context.write(new Text(newKey), NullWritable.get());
                
        	//} catch 
        }
   
	}
}