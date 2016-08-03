CREATE OR REPLACE PROCEDURE insert_inconsistent_block(dbs_block in NUMBER, Phedx_block in NUMBER,Block_size_DBS in NUMBER,file_count_dbs in NUMBER,open_status_DBS in NUMBER,block_size_PhEDX in NUMBER,file_count_PhEDX in NUMBER,open_status_PhEDX in NUMBER) IS
BEGIN

  DECLARE
	unix_time NUMBER;

    BEGIN
    
    unix_time := ( SYSDATE - date '1970-01-01' ) * 60 * 60 * 24;

    unix_time := TRUNC(unix_time);
    
        INSERT INTO INCONSISTENT_BLOCKS (
				DBS_BLOCK_ID,
				PHEDX_BLOCK_ID,
				DISCOVERY_DATE,
				BLOCK_SIZE_DBS,
				BLOCK_SIZE_PhEDX,
				FILE_COUNT_DBS,
				FILE_COUNT_PhEDX,
				OPEN_MISMATCH_DBS,
				OPEN_MISMATCH_PhEDX
				)
				VALUES (
				dbs_block,
				Phedx_block,
				unix_time,
				Block_size_DBS,
				file_count_dbs,
				open_status_DBS,
				block_size_PhEDX,
				file_count_PhEDX,
				open_status_PhEDX
				);

	--dbms_output.put_line('BLOCK Insert Successful');		
  
    END;

END;