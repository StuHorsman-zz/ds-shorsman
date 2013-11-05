package ccp.shorsman.task1;

import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.conf.Configured;
import org.apache.hadoop.fs.Path;
import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Job;
import org.apache.hadoop.mapreduce.lib.input.FileInputFormat;
import org.apache.hadoop.mapreduce.lib.output.FileOutputFormat;
import org.apache.hadoop.util.Tool;
import org.apache.hadoop.util.ToolRunner;

import ccp.shorsman.task2.MapExtractPlayWithoutTV;

public class ExtractPlayWithoutTV extends Configured implements Tool {

	@Override
	public int run(String[] args) throws Exception {
		String input, output;
		if (args.length == 2) {
			input = args[0];
			output = args[1];
		} else {
			System.err.println("Usage: ExtractPlayWithoutTV <input> <output>");
			return -1;
		}
		
		Configuration conf = getConf();
				
		Job job = new Job(conf);
		
		job.setJarByClass(ExtractPlayWithoutTV.class);
		job.setJobName(this.getClass().getName());

		FileInputFormat.addInputPath(job, new Path(input));
		FileOutputFormat.setOutputPath(job, new Path(output));

		job.setMapperClass(MapExtractPlayWithoutTV.class);
		job.setReducerClass(ReduceExtractPlayWithoutTV.class);
		job.setCombinerClass(ReduceExtractPlayWithoutTV.class);

		job.setMapOutputKeyClass(Text.class);
		job.setMapOutputValueClass(IntWritable.class);

		job.setOutputKeyClass(Text.class);
		job.setOutputValueClass(IntWritable.class);
		
	    job.setNumReduceTasks(1);

		boolean success = job.waitForCompletion(true);
		return success ? 0 : 1;
	}

	public static void main(String[] args) throws Exception {
		Configuration conf = new Configuration();
		conf.set("mapred.textoutputformat.separator", ",");
		ExtractPlayWithoutTV driver = new ExtractPlayWithoutTV();
		int exitCode = ToolRunner.run(conf, driver, args);
		System.exit(exitCode);
	}
}












