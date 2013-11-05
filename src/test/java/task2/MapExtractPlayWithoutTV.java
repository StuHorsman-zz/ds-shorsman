package ccp.shorsman.task2;

import java.io.IOException;

import org.apache.hadoop.io.LongWritable;
import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Mapper;
import org.json.simple.JSONObject;
import org.json.simple.JSONValue;

public class MapExtractPlayWithoutTV extends
		Mapper<LongWritable, Text, Text, IntWritable> {

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
                
        		String newKey = user_id.toString() + "," + movie_id;
                
                context.write(new Text(newKey), new IntWritable(1));
                
        	//} catch 
        }
        
        

		

	}
}