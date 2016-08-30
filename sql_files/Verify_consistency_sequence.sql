-- =============================================
-- Author: Shubham Gupta 
-- Create date: 19.08.16
-- Description: The procedure which runs a sequence of other procedures. It effectively is the procedure that 
-- orchestrates the wole consisteny verifiction process. It starts with wiping old data from the tables and then it 
-- runs consistency_verification_2 followed by consistency_verification_phedx and then it runs the file_level_driver 
-- and finally runs file invalidation process. This procedure is expected to be run as a DBMS Job periodically.
-- =============================================
Create or REPLACE Procedure Verify_consistency_Sequence IS

BEGIN

	WIPE_TABLES;
	CONSISTENCY_VERIFICATION;
	CONSISTENCY_VERIFICATION_PHEDX;
	FILE_LEVEL_DRIVER;
	FILE_LEVEL_INVALIDATION;

END;
/
