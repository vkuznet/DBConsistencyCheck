-- =============================================
-- Author: Shubham Gupta 
-- Create date: 19.08.16
-- Description: Finds all the files in DBS for a given DBS block_id and then finds the corresponding file in PhEDEX.
-- If the file is found then compares paramter such as file size and checksums,Adler32 and stores the results via 
-- insert_inconsistent_file procedure if an inconsistency is found. If file is not found in PhEDEX then also an inconsistency 
-- is recorded using the insert_inconsistent_file procedure.
-- =============================================

Create or REPLACE Procedure file_level_verification_phedx( input_block_id IN varchar2)
IS

	BEGIN
  
	 DECLARE

	    rec_dbs_file  CMS_DBS3_PROD_GLOBAL_OWNER.FILES%ROWTYPE;

	    rec1_phedx_file  CMS_TRANSFERMGMT.T_DPS_FILE%ROWTYPE;

	    initial_select NUMBER;
        adler32_value  varchar2(100 BYTE);
        cksum_value  varchar2(100 BYTE);

	  BEGIN
	  
	  	SELECT count(*) INTO initial_select FROM CMS_TRANSFERMGMT.T_DPS_FILE  where CMS_TRANSFERMGMT.T_DPS_FILE.INBLOCK = input_block_id ;
      

	  	IF (initial_select = 0) THEN

	  	continue;	
	  	 --the case where there are no PhEDEx files for a given block id. Nothing to be done here in such a case.
	  	 
		ELSE


	  		FOR rec1_phedx_file IN (SELECT * FROM CMS_TRANSFERMGMT.T_DPS_FILE where CMS_TRANSFERMGMT.T_DPS_FILE.INBLOCK = input_block_id) 
			  LOOP
			  		BEGIN

							SELECT * INTO rec_dbs_file
							FROM CMS_DBS3_PROD_GLOBAL_OWNER.files
							WHERE rec1_phedx_file.LOGICAL_NAME = CMS_DBS3_PROD_GLOBAL_OWNER.files.LOGICAL_file_NAME;

					EXCEPTION

						when NO_DATA_FOUND THEN

						    dbms_output.put_line(' File NOT located in DBS');
					
						    checksum_parser_phedx( rec1_phedx_file.CHECKSUM, adler32_value, cksum_value);

						    insert_inconsistent_file(rec1_phedx_file.LOGICAL_NAME,NULL,NULL,NULL,NULL,rec1_phedx_file.INBLOCK,NULL,adler32_value,NULL,cksum_value,NULL,rec1_phedx_file.FILESIZE);


					END;



			 END LOOP;

		END IF;

	  END;

	END;
/
