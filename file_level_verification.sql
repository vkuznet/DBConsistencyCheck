/* Procedure to Verify Consistency at file level when block id for files is provided as input*/

Create or REPLACE Procedure file_level_verification( input_block_id in varchar2,  status_information_return OUT varchar2 ) IS


    
BEGIN

	  DECLARE

	    rec_dbs_file  cms_dbs3_prod_part.FILES%ROWTYPE;

	    rec1_phedx_file  cms_transfermgmt_part.T_DPS_FILE%ROWTYPE;

	    file_is_consistent boolean;

	    checksum_var varchar2(20);

	    adler32_var varchar2(20);

	   
	  

	  BEGIN

			  FOR rec_dbs_file IN (SELECT * FROM cms_dbs3_prod_part.Files where cms_dbs3_prod_part.Files.block_id = input_block_id) 
			  LOOP
			  
					  BEGIN
            
                status_information_return := 'NORMAL';

					  		file_is_consistent := True;

							  dbms_output.put_line(rec_dbs_file.LOGICAL_FILE_NAME|| ' File located in DBS');

							  SELECT * INTO rec1_phedx_file
							  FROM CMS_TRANSFERMGMT_PART.T_DPS_FILE
							  WHERE rec_dbs_file.LOGICAL_FILE_NAME = cms_transfermgmt_part.T_DPS_FILE.LOGICAL_NAME;

							   dbms_output.put_line(rec1_phedx_file.LOGICAL_NAME|| ' File located in PhEDX');

							   --same File size  check condition
							   
          
						          IF (file_is_consistent  AND rec_dbs_file.file_SIZE != rec1_phedx_file.FILESIZE ) THEN 
						          	file_is_consistent := FALSE;
                        status_information_return := 'ATLEAST_ONE_INCONSISTENT';



						          	--insert row into table

						          END IF;	

						          	-- checksum verification procedure

						          /*checksum_parser_phedx(rec1_phedx_file.CHECKSUM,adler32_var,checksum_var);

						          IF (file_is_consistent  AND  rec_dbs_file.ADLER32 = adler32_var AND rec_dbs_file.CHECK_SUM = checksum_var	) THEN

						          	dbms_output.put_line('checsum consistent hai');

						          END IF;*/




					    EXCEPTION

						        when NO_DATA_FOUND THEN

						        dbms_output.put_line(' File NOT located in PhEDX');

						        status_information_return := 'NO_FILES_FOUND_IN_PHEDX_FROM_DBS';

						        --insert row into table
                    CONTINUE;

					    END;    
			  
			  END LOOP;

	  END;




END;  