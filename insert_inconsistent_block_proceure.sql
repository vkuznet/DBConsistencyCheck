CREATE OR REPLACE PROCEDURE insert_inconsistent_block(dbs_block in NUMBER, Phedx_block in NUMBER, file_status in NUMBER,size_status in NUMBER,count_status in NUMBER,open_status in NUMBER) IS
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
				DISCOVERY_DATE,
				BLOCK_SIZE_STATUS,
				File_count_status,
				OPEN_MISMATCH
				)
				VALUES (
				dbs_block,Phedx_block,file_status,unix_time,size_status,count_status,open_status
				);

	--dbms_output.put_line('BLOCK Insert Successful');		
  
    END;

END;