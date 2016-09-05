-- =============================================
-- Author: Shubham Gupta 
-- Create date: 19.08.16
-- Description: /* Procedure to Verify Consistency at file level when block id for files is provided as input*/
-- Finds all the files in DBS for a given DBS block_id and then finds the corresponding file in PhEDEX. If 
-- the file is found then compares paramter such as file size and checksums,Adler32 and stores the results via 
-- insert_inconsistent_file procedure if an inconsistency is found. If file is not found in PhEDEX then also an 
-- inconsistency is recorded using the insert_inconsistent_file procedure.
-- =============================================


Create or REPLACE Procedure file_level_verification( input_block_id in varchar2) IS


    
BEGIN

	  DECLARE

	    rec_dbs_file  CMS_DBS3_PROD_GLOBAL_OWNER.FILES%ROWTYPE;

	    rec1_phedx_file  CMS_TRANSFERMGMT.T_DPS_FILE%ROWTYPE;

	    file_is_consistent boolean;

	    adler32_value varchar2(30);

	    cksum_value varchar2(30);

	    checksum_status number(1);

	    adler32_status number(1);

	    size_status number(1);


	   
	  

	  BEGIN

			  FOR rec_dbs_file IN (SELECT * FROM CMS_DBS3_PROD_GLOBAL_OWNER.Files where CMS_DBS3_PROD_GLOBAL_OWNER.Files.block_id = input_block_id) 
			  LOOP
			  
					  BEGIN
            
  					  		file_is_consistent := True;

					  		checksum_status := 1;
							adler32_status	:= 1;
							size_status	:= 1;

							  dbms_output.put_line(rec_dbs_file.LOGICAL_FILE_NAME|| ' File located in DBS');

							  SELECT * INTO rec1_phedx_file
							  FROM CMS_TRANSFERMGMT.T_DPS_FILE
							  WHERE rec_dbs_file.LOGICAL_FILE_NAME = CMS_TRANSFERMGMT.T_DPS_FILE.LOGICAL_NAME;

							   dbms_output.put_line(rec1_phedx_file.LOGICAL_NAME|| ' File located in PhEDX');

							   --same File size  check condition
							   
          
						          IF (rec_dbs_file.file_SIZE != rec1_phedx_file.FILESIZE ) THEN 
						          	file_is_consistent := FALSE;
						          	size_status := 0 ;

						          END IF;	


						          	checksum_parser_phedx( rec1_phedx_file.checksum , adler32_value, cksum_value);


						          IF (rec_dbs_file.CHECK_SUM != cksum_value AND (rec_dbs_file.CHECK_SUM != NULL AND cksum_value != 0))  THEN 
						          	file_is_consistent := FALSE;
						          	 checksum_status := 0 ;

						          END IF;

						          IF (rec_dbs_file.ADLER32 != adler32_value AND (rec_dbs_file.ADLER32 != 'NOTSET' AND adler32_value != 0)) THEN 
						          	file_is_consistent := FALSE;
						          	 adler32_status := 0 ;

						          END IF;		

                        		 IF (file_is_consistent = FALSE) THEN 	

						           insert_inconsistent_file(rec_dbs_file.LOGICAL_FILE_NAME,checksum_status,adler32_status, size_status,rec_dbs_file.block_id,rec1_phedx_file.INBLOCK,rec_dbs_file.CHECK_SUM,cksum_value ,rec_dbs_file.ADLER32,adler32_value,rec_dbs_file.file_SIZE,rec1_phedx_file.FILESIZE);

						          END IF;	

					    EXCEPTION

						        when NO_DATA_FOUND THEN
						        insert_inconsistent_file(rec_dbs_file.LOGICAL_FILE_NAME,NULL,NULL,NULL,rec_dbs_file.block_id,NULL,rec_dbs_file.CHECK_SUM,NULL,rec_dbs_file.ADLER32,NULL,rec_dbs_file.file_SIZE,NULL);
                    CONTINUE;

					    END;    
			  
			  END LOOP;

	  COMMIT;
	  END;




END;
/  
