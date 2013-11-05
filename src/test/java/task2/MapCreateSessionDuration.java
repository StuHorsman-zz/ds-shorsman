package ccp.shorsman.task2;

import java.io.IOException;

import org.apache.hadoop.io.LongWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Mapper;

public class MapCreateSessionDuration extends
		Mapper<LongWritable, Text, Text, Text> {

	@Override
	public void map(LongWritable key, Text value, Context context)
			throws IOException, InterruptedException {

		String line = value.toString();

		String[] splitValues = line.split("\t");

		String sessionId = splitValues[0];
		String userId = splitValues[1];
		String createdAt = splitValues[2];
		String action = splitValues[3];
		String movieId = splitValues[4];

		String newKey = sessionId + "\t" + userId;
		String newValue = createdAt + "\t" + action + "\t" + movieId;

		context.write(new Text(newKey), new Text(newValue));

	}
}