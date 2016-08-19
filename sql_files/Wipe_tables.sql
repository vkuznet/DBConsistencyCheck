-- =============================================
-- Author: Shubham Gupta 
-- Create date: 19.08.16
-- Description: Truncates the contents of inconsistent_blocks, inconsistent_files,
-- invalid_dbs_blocks tables. this procedure is normally executed before every run of
-- consistency_verification_sequence to truncate and clear the tables of their old
-- contents.Can also be called seperately if required to clear the tables.
-- =============================================
Create or REPLACE Procedure wipe_tables IS
BEGIN

	execute immediate 'truncate table inconsistent_blocks';
	execute immediate 'truncate table inconsistent_files';
	execute immediate 'truncate table invalid_dbs_blocks';
		commit;

END;
/
