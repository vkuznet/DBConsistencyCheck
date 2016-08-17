# Details about the SQL Procedures

# Checksum\_parser\_phedx

Phedex and DBS store checksums in different ways. While DBS has seperate fields for each type of checksum, Phedex stores all checksume in a single field as a set of key value pairs.

This procedure takes the string of key value pairs of phedex checksums as input and provides output in the form of Adler32 and Checksum.These values are then used for comparison of files between DBS and PhEDEX.

#Table\_create

Contains all the SQL satements that are used to create the tables, sequences and triggers required by the procedures.The sequences and triggers are used in alloting a unique ID to each record of the tables automatically.

 
# Insert\_inconsistent\_block\_procedure
 
This procedure's function is to insert a record into the inconsistent\_blocks table.The reason behind creating this procedure rather than using a direct insert statement was to make it to easier and shorter to use insertion and also as capabilities like producing the time stamp and converting it into unix time can be handled bythe procedure automatically.

# Insert\_inconsistent\_file

Performs identical functions as the insert\_inconsistent\_block but for inconsistent files.

# Wipe\_tables

Truncates the contents of inconsistent\_blocks, inconsistent\_files, invalid\_dbs\_blocks tables. this procedure is normally executed before every run of consistency\_verification\_sequence to truncate and clear the tables of their old contents.Can also be called seperately if required to clear the tables.

# File\_level\_driver

Scans inconsistent\_blocks table for cases where blocks from DBS have their counterpart from PhEDEX and then calls the procedures file\_level\_verification and file\_level\_verification\_phedx for each such block found in the inconsistent\_blocks tables.

# File\_level\_verification

Finds all the files in DBS for a given DBS block\_id and then finds the corresponding file in PhEDEX. If the file is found then compares paramter such as file size and checksums,Adler32 and stores the results via insert\_inconsistent\_file procedure if an inconsistency is found. If file is not found in PhEDEX then also an inconsistency is recorded using the insert\_inconsistent\_file procedure.

# File\_level\_verification\_phedx

Performs the same function as file\_level\_verification but from phedex's side.It iterates over files in PhEDX's T\_DPS\_FILE finding files with a given input of a  block\_id to verify the existence of the same 
files in DBS's table of FILES. It does not perform parameter checking processes as that is already handled by the file\_level\_verification and if files of PhEDX are present in DBS then their parameters are assumed to have been 
checked and handled by the other procedure.This procedure Just detects absence of PhEDX files in DBS. 

# File\_level\_invalidation

Finds all DBS blocks from the inconsistent\_blocks tables which have no equivalent PhEDEX counterpart and then scans all of their files for the validity status of the files. If all files are found to be invalid then this is stored in the invalid\_dbs\_blocks. It also stores the field IS\_BLOCK\_INVALID as 1. If not all files are invalid, the IS\_BLOCK\_INVALID is stored as zero along with the number of invalid and total files.
Also if the number of invalid files is found to be zero then details of such a block are not recorded in the invalid\_dbs\_blocks table.

# Consistency\_verification\_2

One of the important procedures. This procedure scans the BLOCKS table in DBS and T\_DPS\_BLOC table in PhEDEX to find inconsistent blocks by comparing parameters such as block size, the number of files in the block (file count) and also the open/close status of the block. Blocks where these parameters don't match or cases where there is a DBS block for which a PhEDEX block is not found are then stored in the inconsitent\_blocks table using the insert\_inconsistent\_block\_procedure.

# Consistency\_verification\_phedx

Performs the same function as consistency\_verification\_2 but from PhEDEX's side.It iterates over BLOCKS in PhEDX's T\_DPS\_BLOCk trying to find  the same 
block in DBS's table of blocks.If the PhEDEX Block is also found in DBS then the procedure moves on to the next block, it does not perform parameter checking processes as that is already handled by the consistency\_verification\_2 and if blocks of PhEDEX are present in DBS then their parameters are assumed to have been 
checked and handled by the other procedure.This procedure Just detects absence of PhEDX blocks in DBS.

# Verify\_consistency\_sequence

The procedure which runs a sequence of other procedures. it efectively is the procedure that orchestrates the wole consisteny verifiction process. It starts with wiping old data from the tables and then it runs consistency\_verification\_2 followed by consistency\_verification\_phedx and then it runs the file\_level\_driver and finally runs file invalidation process. This procedure is expected to be run as a DBMS Job periodically.
