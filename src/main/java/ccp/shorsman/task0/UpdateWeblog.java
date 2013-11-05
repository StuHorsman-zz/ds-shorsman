// UpdateWeblog application
package ccp.shorsman.task0;

import org.apache.hadoop.conf.Configured;
import org.apache.hadoop.fs.Path;
import org.apache.hadoop.io.NullWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Job;
import org.apache.hadoop.mapreduce.lib.input.FileInputFormat;
import org.apache.hadoop.mapreduce.lib.output.FileOutputFormat;
import org.apache.hadoop.util.Tool;
import org.apache.hadoop.util.ToolRunner;

public class UpdateWeblog extends Configured implements Tool {

	@Override
	public int run(String[] args) throws Exception {
		String input1, input2, output;
		if (args.length == 3) {
			input1 = args[0];
			input2 = args[1];
			output = args[2];
		} else {
			System.err.println("Usage: UpdateWeblog <input1> <input2> <output>");
			return -1;
		}

		Job job = new Job(getConf());
		job.setJarByClass(UpdateWeblog.class);
		job.setJobName(this.getClass().getName());

		FileInputFormat.addInputPath(job, new Path(input1));
		FileInputFormat.addInputPath(job, new Path(input2));
		FileOutputFormat.setOutputPath(job, new Path(output));

		job.setMapperClass(MapUpdateWeblog.class);
		job.setReducerClass(ReduceUpdateWeblog.class);

		job.setMapOutputKeyClass(Text.class);
		job.setMapOutputValueClass(NullWritable.class);

		job.setOutputKeyClass(Text.class);
		job.setOutputValueClass(NullWritable.class);
		
	    job.setNumReduceTasks(1);

		boolean success = job.waitForCompletion(true);
		return success ? 0 : 1;
	}

	public static void main(String[] args) throws Exception {
		UpdateWeblog driver = new UpdateWeblog();
		int exitCode = ToolRunner.run(driver, args);
		System.exit(exitCode);
	}
}












