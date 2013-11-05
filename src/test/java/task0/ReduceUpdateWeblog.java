// ReduceUpdateWeblog writes out the formatted input from mapper
package ccp.shorsman.task0;

import java.io.IOException;

import org.apache.hadoop.io.NullWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Reducer;

public class ReduceUpdateWeblog
  extends Reducer<Text, NullWritable, Text, NullWritable> {
  
  @Override
  public void reduce(Text key, Iterable<NullWritable> values,
      Context context)
      throws IOException, InterruptedException {
    
    context.write(key, NullWritable.get());
  }
}

