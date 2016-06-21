
## Objective 

The objective of this project is to find the optimal way to find inconsistencies between the DBS and PhEDEX databases which are being used to store CMS meta data.

## Approaches to Achieving Consistency verification

1. Using oracle tools.
2. Using HDFS as the data source for comparison through Spark (Pyspark is prefered).

## Outputs of consistency verification operation

The outputs is expected to be dumped as a CSV (comma separated Values) file with the following format.

`id,database,block_name,number_of_files,Size,state,id,database,block_name,number_of_files,Size,state,....`
 
## Possible cases of inconsistency

There should be three broad cases of inconsistency which are expected to be extracted.

1. A block is present in DBS but not in PhEDEx. An example of such an output would be 

   `845055,/QCD/v1/AODSIM,/QCD/v1/AODSIM#123,432,2852194134,n, , , , , , ,`

2. A block is not present in DBS but it is present in PhEDEx. An example of such an output would be

   ` , , , , , ,845055,/QCD/v1/AODSIM,/QCD/v1/AODSIM#123,432,2852194134,n`

3. Both DBS and PhEDEX have the data blocks but parameters like size or number of files do not match.
An example for this would be 

   `845055,/QCD/v1/AODSIM,/QCD/v1/AODSIM#123,432,2852194134,n,845055,/QCD/v1/AODSIM,/QCD/v1/AODSIM#123,450,2852304134,n`

## Initial Approach and steps for Oracle tools

1. Exploring Oracle tools and methods available for comparison.
2. Using these tools for a command line based retrieval and comparison of the data.
3. Evaluating Performance of the methods.
4. Creating the programs that utilise these methods.
5. Evaluating Program and discusiing scalability issues.
6. Improving and testing the program.

## Possible approaches for the program
1. Sorting the block records by name and then comparing.
2. Taking a union of the two tables and then comparing (may have negative impact on performance).

## Final Goal
The consistency verification tool that would be created would be run periodically, frequency of which will depend on the speed of the consistency verification operations.The CSV file then can be placed in elastic search and kibana for a web interface or other Javascript frameworks can also be used to parse the CSV file to a human readable format.


