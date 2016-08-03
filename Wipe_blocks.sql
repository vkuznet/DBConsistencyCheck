Create or REPLACE Procedure wipe_blocks IS
BEGIN

	delete from inconsistent_blocks;
		commit;

END;