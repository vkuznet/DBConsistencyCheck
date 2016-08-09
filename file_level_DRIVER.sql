Create or REPLACE Procedure file_level_driver IS


    
BEGIN

	  DECLARE

	  rec_inconsistent_blocks CMS_DBS_TRANF_VER.inconsistent_blocks%ROWTYPE;

	  BEGIN
	  	
	  	  FOR rec_inconsistent_blocks IN (SELECT * FROM inconsistent_blocks where inconsistent_blocks.phedx_block_id IS NOT NULL) 
			  LOOP
			  
					  BEGIN

					  file_level_verification(rec_inconsistent_blocks.dbs_block_id);
					  file_level_verification_phedx(rec_inconsistent_blocks.phedx_block_id);


					  END;
			  End LOOP;		  


	  END;
END;
