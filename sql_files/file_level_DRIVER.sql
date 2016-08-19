-- =============================================
-- Author: Shubham Gupta 
-- Create date: 19.08.16
-- Description: Scans inconsistent_blocks table for cases where blocks from DBS have their counterpart from 
-- PhEDEX and then calls the procedures file_level_verification and file_level_verification_phedx for each such 
-- block found in the inconsistent_blocks tables.
-- =============================================
Create or REPLACE Procedure file_level_driver IS


    
BEGIN

	  DECLARE

	  rec_inconsistent_blocks inconsistent_blocks%ROWTYPE;

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
/
