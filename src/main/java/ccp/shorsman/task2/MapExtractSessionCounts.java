// MapExtractSessionCounts maps data from CreateSessionDuration
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
		
		action = action + "," + createdAt + "," + duration + "," + movieId;

		context.write(new Text(sessionId), new Text(action));

	}

}
