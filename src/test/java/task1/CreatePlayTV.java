package ccp.shorsman.task1;

import org.apache.hadoop.conf.Configured;
import org.apache.hadoop.fs.Path;
import org.apache.hadoop.io.NullWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Job;
import org.apache.hadoop.mapreduce.lib.input.FileInputFormat;
import org.apache.hadoop.mapreduce.lib.output.FileOutputFormat;
import org.apache.hadoop.util.Tool;
import org.apache.hadoop.util.ToolRunner;

import ds.shorsman.CreatePlay;
import ds.shorsman.MapCreatePlay;

public class CreatePlayTV extends Configured implements Tool {

	@Override
	public int run(String[] args) throws Exception {
		String input, output;
		if (args.length == 2) {
			input = args[0];
			output = args[1];
		} else {
			System.err.println("Usage: CreatePlayTV <input> <output>");
			return -1;
		}

		Job job = new Job(getConf());
		job.setJarByClass(CreatePlay.class);
		job.setJobName(this.getClass().getName());

		FileInputFormat.addInputPath(job, new Path(input));
		FileOutputFormat.setOutputPath(job, new Path(output));

		job.setMapperClass(MapCreatePlay.class);
		job.setReducerClass(ReduceCreatePlayWithoutTV.class);

		job.setMapOutputKeyClass(Text.class);
		job.setMapOutputValueClass(NullWritable.class);

		job.setOutputKeyClass(Text.class);
		job.setOutputValueClass(NullWritable.class);
		
	    job.setNumReduceTasks(1);

		boolean success = job.waitForCompletion(true);
		return success ? 0 : 1;
	}

	public static void main(String[] args) throws Exception {
		CreatePlay driver = new CreatePlay();
		int exitCode = ToolRunner.run(driver, args);
		System.exit(exitCode);
	}
}












