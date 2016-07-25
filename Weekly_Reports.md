# Reports

## Week 1

* Created VM instances from the cern Open Stack resources.

* Created [Direction.md](https://github.com/aerophile/DBConsistencyCheck/blob/master/Direction.md) document.

* The format for the inconsistency reporting log files was decided and agreed upon. (See [Direction.md](https://github.com/aerophile/DBConsistencyCheck/blob/master/Direction.md) )

* Downloaded and installed SQL Developer, which was especially troublesome for configuring jdk and took way too much time and too many attempts to get it working.

* Access to copies of oracle databases of DBS and PhEDX were obtained and connections were made and tested through SQLdeveloper and SQLplus.

* Studied Schema descriptions for DBS (BLOCKS) and PhEDX (T\_DPS\_BLOCKS) databases.   


* Working on step 2 of the approach as described in the direction document and creating stored procedures to perform basic consistency verification steps.

## Week 2

* Granted cms\_dbs\_tranf\_ver schema the table access grants from DBS schema (cms\_dbs3\_prod\_part) and PhEDX ( cms\_transfermgmt\_part )which allowed both tables to be accessed through cms\_dbs\_tranf\_ver schema.

* Created a Basic [stored\_procedure](https://github.com/aerophile/DBConsistencyCheck/blob/master/stored\_procedure) that could retrieve PhEDX records for each of the dbs records, if the corresponding PhEDX records exist.

* Further developed this [stored\_procedure](https://github.com/aerophile/DBConsistencyCheck/blob/master/stored\_procedure) into a [Consistency\_check\_Basic]( https://github.com/aerophile/DBConsistencyCheck/blob/master/Consistency\_check\_Basic.sql ) file which uses 3 conditions such as File Count, File Size, and Block open/Closed status and also accounts for absence of DBS Block records in PhEDX.

* Used  [Consistency\_check\_Basic](https://github.com/aerophile/DBConsistencyCheck/blob/master/Consistency\_check\_Basic.sql) program to get 22,469 inconsistencies of which 21,873 are DBS Blocks that are not present in PhEDX and the remaing 596 have other types of inconsistencies such as FileCount(499), FileSize(498), Block open/close(124).

* These figures may not be entirely accurate as [Consistency\_check\_Basic](https://github.com/aerophile/DBConsistencyCheck/blob/master/Consistency\_check\_Basic.sql) does not check for Blocks of PhEDX that are missing in DBS and also does not account for conditions such as test blocks which are allowed to remain inconsistent.

* Working on the structre of the table for storing details of block level inconsistencies.

## Week 3

* Modularized most of the code into procedures which can be called by the main program for consistency verification. 

* Encountered a new type of error (TOO_MANY_ROWS) when converting Block consistecy code to a procedure. The cause of the error was the presence of BLOCKs with same names in PhEDX. This is allowed as the blocks can have same names and can belong to different DBS's that is they all may not belong to the GLOBAL production DBS. Resolving this error requires the creation of a special procedure to handle this exceptional case.

* Also Learnt about the differnt methods of data removal in DBS and PhEDX. While PhEDX removes and deletes data that is no longer required, DBS on the other hand stores such data along with parameters that declare it invalid. These parameters are stored either at the dataset level or at the File level. So this is the reason why earlier most of the inconsistencies were of the type present in DBS but not in PhEDX as most of these were invalid state/deleted Blocks.   

* Developed the filelevel consistency verification procedure  wich takes the BLOCK ID as input to obtain files with the same Logical File name and checks for consistency of files by compairing checksums and Filesizes.

* The method of storing Checksums is different in both Databases. In DBS, the files table has seperate columns for adler32 as well as cksum. MD5 column is also present but it is not being used consistency verification purposes. PhEDX stores all checksum values in a single column in a comma seperated key value format. Built a parser procedure for this column to return the parsed checksum values for verifying their consistency.

* Currently working on integrating block and file level procedures along with error records insertion procedures.

## Week 4

* Created and tested File and Block Inconsistency tables. Also created the procedures ( [insert\_inconsistent\_block]() , [insert\_inconsistent\_file]() ) to store the details about the inconsitencies encountered. 

* Integrated all the seperate procedures.

* Encountered the buffer overflow error that limits the output of dbms_output.put_line to 1,000,000 bytes. This limit can be one ofthe causes to incorrect number of inconsistencies deteced. Recording inconsistencies in a table should resolve this problem.

* Added all of the procedures created so far to the github repository.

## Week 5

* Created File_level_invalidation procedure that goes through the inconsistent_blocks table and is able to produce details of blocks which have all invalid files in DBS and store them in invalid_dbs_blocks table.


* Created a lighter version of consistency_verification procedure to aid the inconsistency verification procedure .

* Did some basic tests on all of consistency verification procedures which included data being inserted into inconsistent_blocks and inconsistent_files tables.

* As a result of the newly created insertion procedures, new insight into the number of inconsistencies was made, the latest numbers are 966,142 inconsistent blocks of which 133,643 were found to be invalid. 104,868 blocks have differences in file count, size or block open/close status.

* Currently working on implementing Command line interface and it associated functions for consistency verification procedure. 




