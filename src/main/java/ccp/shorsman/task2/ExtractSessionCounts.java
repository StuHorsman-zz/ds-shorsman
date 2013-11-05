// ExtractSessionCounts application
package ccp.shorsman.task2;

import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.conf.Configured;
import org.apache.hadoop.fs.Path;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Job;
import org.apache.hadoop.mapreduce.lib.input.FileInputFormat;
import org.apache.hadoop.mapreduce.lib.output.FileOutputFormat;
import org.apache.hadoop.util.Tool;
import org.apache.hadoop.util.ToolRunner;

public class ExtractSessionCounts extends Configured implements Tool {

	@Override
	public int run(String[] args) throws Exception {
		String input, output;
		if (args.length == 2) {
			input = args[0];
			output = args[1];
		} else {
			System.err.println("Usage: ExtractSessionCounts <input> <output>");
			return -1;
		}
		
		Configuration conf = getConf();
				
		Job job = new Job(conf);
		
		job.setJarByClass(ExtractSessionCounts.class);
		job.setJobName(this.getClass().getName());

		FileInputFormat.addInputPath(job, new Path(input));
		FileOutputFormat.setOutputPath(job, new Path(output));

		job.setMapperClass(MapExtractSessionCounts.class);
		job.setReducerClass(ReduceExtractSessionCounts.class);
		
		job.setMapOutputKeyClass(Text.class);
		job.setMapOutputValueClass(Text.class);

		job.setOutputKeyClass(Text.class);
		job.setOutputValueClass(Text.class);
		
	    job.setNumReduceTasks(1);

		boolean success = job.waitForCompletion(true);
		return success ? 0 : 1;
	}

	public static void main(String[] args) throws Exception {
		Configuration conf = new Configuration();
		conf.set("mapred.textoutputformat.separator", ",");
		ExtractSessionCounts driver = new ExtractSessionCounts();
		int exitCode = ToolRunner.run(conf, driver, args);
		System.exit(exitCode);
	}
}












