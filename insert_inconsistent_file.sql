CREATE OR REPLACE PROCEDURE insert_inconsistent_file(lfn in varchar2, cksum in number, adler32 in number , size_value in number,block_id_dbs in number,block_id_phedx in number) IS
BEGIN

  DECLARE
	unix_time NUMBER;

    BEGIN
    
    unix_time := ( SYSDATE - date '1970-01-01' ) * 60 * 60 * 24;

    unix_time := TRUNC(unix_time);
    
        INSERT INTO INCONSISTENT_FILES(
					
					LOGICAL_FILE_NAME ,
					CKSUM_RESULT ,
					ADLER32_RESULT,
					SIZE_RESULT ,
					BLOCK_ID_DBS ,
					BLOCK_ID_PHEDX,
					FILE_DISCOVERY_DATE 
					)
        values(lfn,cksum,adler32,size_value,block_id_dbs,block_id_phedx,unix_time);

	dbms_output.put_line('File Insert Successful');		
  
    END;

END;