Create or REPLACE Procedure wipe_tables IS
BEGIN

	execute immediate 'truncate table inconsistent_blocks';
	execute immediate 'truncate table inconsistent_files';
	execute immediate 'truncate table invalid_dbs_blocks';
		commit;

END;
/
