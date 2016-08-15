/* This Function iterates over files in PhEDX's T_DPS_FILE table using a block_id to verify the existence of the same 
files in DBS's table of FILES. It does not need to perform parameter checking processes as that is already handled
by the file_level_verification and if files of PhEDX are present in DBS then their parameters are assumed to have been
Checked and handled by the other procedure.This procedure Just detects absence of PhEDX files in DBS files.*/

Create or REPLACE Procedure file_level_verification_phedx( input_block_id IN varchar2)--, status_information_return OUT varchar2 ) 
IS

	BEGIN
  
	 DECLARE

	    rec_dbs_file  cms_dbs3_prod_part.FILES%ROWTYPE;

	    rec1_phedx_file  cms_transfermgmt_part.T_DPS_FILE%ROWTYPE;

	    initial_select NUMBER;
      --input_block_id varchar2(30);
      adler32_value  varchar2(100 BYTE);
       cksum_value  varchar2(100 BYTE);

	  BEGIN
	    
	  	--SELECT ID INTO input_block_id from CMS_TRANSFERMGMT_PART.T_DPS_BLOCK where CMS_TRANSFERMGMT_PART.T_DPS_BLOCK.NAME = input_block_name ;
	  	SELECT count(*) INTO initial_select FROM CMS_TRANSFERMGMT_PART.T_DPS_FILE  where CMS_TRANSFERMGMT_PART.T_DPS_FILE.INBLOCK = input_block_id ;
      

	  	IF (initial_select = 0) THEN

	  	 dbms_output.put_line(' No Rows Selected in PhEDX');
	  	 --status_information_return := 'NO_FILES_FOUND_IN_PHEDX';

	  	 --code to add all files into the file inconsistency table
	  	 

	  	ELSE

	  		--status_information_return := 'NORMAL';

	  		FOR rec1_phedx_file IN (SELECT * FROM CMS_TRANSFERMGMT_PART.T_DPS_FILE where CMS_TRANSFERMGMT_PART.T_DPS_FILE.INBLOCK = input_block_id) 
			  LOOP
			  		BEGIN

							SELECT * INTO rec_dbs_file
							FROM cms_dbs3_prod_part.files
							WHERE rec1_phedx_file.LOGICAL_NAME = cms_dbs3_prod_part.files.LOGICAL_file_NAME;

							--dbms_output.put_line(rec1_phedx_file.LOGICAL_NAME || ' File located again in DBS');

					EXCEPTION

						when NO_DATA_FOUND THEN

						    dbms_output.put_line(' File NOT located in DBS');
						    --status_information_return := 'ATLEAST_ONE_MISING_IN_DBS';
						    --code to add this file into the file inconsistency table
						    --insert_inconsistent_file(rec1_phedx_file.LOGICAL_NAME,2,2,2,0,rec1_phedx_file.INBLOCK);
						    checksum_parser_phedx( rec1_phedx_file.CHECKSUM, adler32_value, cksum_value);

						    insert_inconsistent_file(rec1_phedx_file.LOGICAL_NAME,NULL,NULL,NULL,NULL,rec1_phedx_file.INBLOCK,NULL,adler32_value,NULL,cksum_value,NULL,rec1_phedx_file.FILESIZE);


					END;



			 END LOOP;

		END IF;

	  END;

	END;
/
