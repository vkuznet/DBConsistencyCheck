CREATE OR REPLACE PROCEDURE insert_inconsistent_block(dbs_block in NUMBER, Phedx_block in NUMBER, file_status in NUMBER) IS
BEGIN

  DECLARE
	unix_time NUMBER;

    BEGIN
    
    unix_time := ( SYSDATE - date '1970-01-01' ) * 60 * 60 * 24;

    unix_time := TRUNC(unix_time);
    
        INSERT INTO INCONSISTENT_BLOCKS (
				DBS_BLOCK_ID,
				PHEDX_BLOCK_ID,
				CONTAINS_FILES,
				DISCOVERY_DATE)
				VALUES (
				dbs_block,Phedx_block,file_status,unix_time
				);

	dbms_output.put_line('BLOCK Insert Successful');		
  
    END;

END;