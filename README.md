
# Cloudera Certified Data Scientist
### Stuart Horsman (stuart.horsman@gmail.com)


The data product contains the following as requested by the submission procedure:

1. An abstract in PDF format that describes your approach to solving each of the 
three parts of the challenge. Please limit the length of the abstract to 
5 pages. => Found in `./docs/Abstract.pdf`

2. Instructions for running your data product => found in `./docs/Instructions.pdf`

3. Any binary files for running your data product => found in the `./bin` directory.

4. The three solution files called Task1Solution.csv, Task2Solution.csv, and 
Task3Solution.csv => found in the `./output` directory

5. The source files for your data product -> found in the `./src` directory


## Mahout instructions

This describes how to compile Mahout, required for task3.

1. Get a copy of Mahout 0.8 and extract it into `~/ds-shorsman`

2. Copy `PredictorEvaluator.java` in the Mahout src:
     
		cp ~/ds-shorsman/src/main/java/ccp/shorsman/mahout/PredictorEvaluator.java ~/mahout/core/src/main/java/org/apache/mahout/cf/taste/hadoop/als
 
3. Copy properties files into src/conf:
 

		cp ~/ds-shorsman/src/main/java/ccp/shorsman/mahout/*.props ~/mahout/src/conf


4. Compile and install:

		cd ~/mahout; mvn clean install

