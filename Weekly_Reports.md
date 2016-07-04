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





