-- =============================================
-- Author: Shubham Gupta 
-- Create date: 19.08.16
-- Description: /* Procedure to scan inconsistent_blocks table  and insert block_ids of invalid blocks to invalid_dbs_blocks table */
-- Finds all DBS blocks from the inconsistent_blocks tables which have no equivalent PhEDEX counterpart and then scans all of their 
-- files for the validity status of the files. If all files are found to be invalid then this is stored in the invalid_dbs_blocks. It  
-- also stores the field IS_BLOCK_INVALID as 1. If not all files are invalid, the IS_BLOCK_INVALID is stored as zero along with the 
-- number of invalid and total files. Also if the number of invalid files is found to be zero then details of such a block are not
-- recorded in the invalid_dbs_blocks table.
-- =============================================


Create or REPLACE Procedure file_level_invalidation IS


    
BEGIN

	  DECLARE

	    rec_INCONSISTENT_BLOCKS  INCONSISTENT_BLOCKS%ROWTYPE;

	    rec_dbs_file  CMS_DBS3_PROD_GLOBAL_OWNER.FILES%ROWTYPE;

	    invalid_file_counter number;

	    file_counter number;
	    unix_time number;
			

	   
	  

	  BEGIN
			  FOR rec_INCONSISTENT_BLOCKS IN (SELECT * FROM INCONSISTENT_BLOCKS where INCONSISTENT_BLOCKS.phedx_block_id IS NULL) 
			  LOOP
			  
					  BEGIN

					  	invalid_file_counter := 0;

					  	SELECT count(*) into file_counter from CMS_DBS3_PROD_GLOBAL_OWNER.Files where CMS_DBS3_PROD_GLOBAL_OWNER.Files.block_id = rec_INCONSISTENT_BLOCKS.dbs_block_id ;

					  	 FOR rec_dbs_file IN (SELECT * FROM CMS_DBS3_PROD_GLOBAL_OWNER.Files where CMS_DBS3_PROD_GLOBAL_OWNER.Files.block_id = rec_INCONSISTENT_BLOCKS.dbs_block_id ) 
			  			 LOOP
			  
					  		BEGIN

							IF (rec_dbs_file.is_file_valid = 0) THEN

								invalid_file_counter := invalid_file_counter + 1;

								

							END IF;
					  
					  		END;

					  	END LOOP;

					  	    unix_time := ( SYSDATE - date '1970-01-01' ) * 60 * 60 * 24;

   							unix_time := TRUNC(unix_time);

					  	IF (invalid_file_counter = file_counter) THEN

								insert into invalid_dbs_blocks
									values(rec_INCONSISTENT_BLOCKS.dbs_block_id,file_counter,invalid_file_counter,1,unix_time);
									

							ELSIF (invalid_file_counter != 0) THEN
							
								insert into invalid_dbs_blocks
									values(rec_INCONSISTENT_BLOCKS.dbs_block_id,file_counter,invalid_file_counter,0,unix_time);
									

							END IF;
					  	
					  	END;	

            COMMIT;
                 
			  END LOOP;

	  END;

END;
/  
