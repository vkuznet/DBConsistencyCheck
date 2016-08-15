/* Procedure to Verify Consistency at file level when block id for files is provided as input*/

Create or REPLACE Procedure file_level_verification( input_block_id in varchar2) IS


    
BEGIN

	  DECLARE

	    rec_dbs_file  cms_dbs3_prod_part.FILES%ROWTYPE;

	    rec1_phedx_file  cms_transfermgmt_part.T_DPS_FILE%ROWTYPE;

	    file_is_consistent boolean;

	    adler32_value varchar2(30);

	    cksum_value varchar2(30);

	    checksum_status number(1);

	    adler32_status number(1);

	    size_status number(1);


	   
	  

	  BEGIN

			  FOR rec_dbs_file IN (SELECT * FROM cms_dbs3_prod_part.Files where cms_dbs3_prod_part.Files.block_id = input_block_id) 
			  LOOP
			  
					  BEGIN
            
                --status_information_return := 'NORMAL';

					  		file_is_consistent := True;

					  		checksum_status := 1;
							adler32_status	:= 1;
							size_status		:= 1;

							  dbms_output.put_line(rec_dbs_file.LOGICAL_FILE_NAME|| ' File located in DBS');

							  SELECT * INTO rec1_phedx_file
							  FROM CMS_TRANSFERMGMT_PART.T_DPS_FILE
							  WHERE rec_dbs_file.LOGICAL_FILE_NAME = cms_transfermgmt_part.T_DPS_FILE.LOGICAL_NAME;

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

                        		  --status_information_return := 'ATLEAST_ONE_INCONSISTENT';


                        		 IF (file_is_consistent = FALSE) THEN 	
						          	--insert row into table

						           insert_inconsistent_file(rec_dbs_file.LOGICAL_FILE_NAME,checksum_status,adler32_status, size_status,rec_dbs_file.block_id,rec1_phedx_file.INBLOCK,rec_dbs_file.CHECK_SUM,cksum_value ,rec_dbs_file.ADLER32,adler32_value,rec_dbs_file.file_SIZE,rec1_phedx_file.FILESIZE);

						          END IF;	

						          	-- checksum verification procedure

						          /*checksum_parser_phedx(rec1_phedx_file.CHECKSUM,adler32_var,checksum_var);

						          IF (file_is_consistent  AND  rec_dbs_file.ADLER32 = adler32_var AND rec_dbs_file.CHECK_SUM = checksum_var	) THEN

						          	dbms_output.put_line('checsum consistent hai');

						          END IF;*/




					    EXCEPTION

						        when NO_DATA_FOUND THEN

						        --dbms_output.put_line(' File NOT located in PhEDX');

						        --status_information_return := 'NO_FILES_FOUND_IN_PHEDX_FROM_DBS';

						        --insert row into table

						        insert_inconsistent_file(rec_dbs_file.LOGICAL_FILE_NAME,NULL,NULL,NULL,rec_dbs_file.block_id,NULL,rec_dbs_file.CHECK_SUM,NULL,rec_dbs_file.ADLER32,NULL,rec_dbs_file.file_SIZE,NULL);
                    CONTINUE;

					    END;    
			  
			  END LOOP;

	  COMMIT;
	  END;




END;
/  
