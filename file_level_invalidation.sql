/* Procedure to scan inconsistent_blocks table  and insert block_ids of invalid blocks to invalid_dbs_blocks table */

Create or REPLACE Procedure file_level_invalidation IS


    
BEGIN

	  DECLARE

	    rec_INCONSISTENT_BLOCKS  INCONSISTENT_BLOCKS%ROWTYPE;

	    rec_dbs_file  cms_dbs3_prod_part.FILES%ROWTYPE;

	    invalid_file_counter number;

	    file_counter number;
			

	   
	  

	  BEGIN



	  		
			
			  FOR rec_INCONSISTENT_BLOCKS IN (SELECT * FROM INCONSISTENT_BLOCKS where INCONSISTENT_BLOCKS.phedx_block_id = 0) 
			  LOOP
			  
					  BEGIN

					  	invalid_file_counter := 0;

					  	--file_counter  := 0;

					  	SELECT count(*) into file_counter from cms_dbs3_prod_part.Files where cms_dbs3_prod_part.Files.block_id = rec_INCONSISTENT_BLOCKS.dbs_block_id ;

					  	 FOR rec_dbs_file IN (SELECT * FROM cms_dbs3_prod_part.Files where cms_dbs3_prod_part.Files.block_id = rec_INCONSISTENT_BLOCKS.dbs_block_id ) 
			  			 LOOP
			  
					  		BEGIN

					  		--file_counter := file_counter + 1;

					  		/*
					  		SELECT * INTO rec_dbs_file
							FROM cms_dbs3_prod_part.files
							WHERE cms_dbs3_prod_part.files.block_id = rec_INCONSISTENT_BLOCKS.dbs_block_id; */


							IF (rec_dbs_file.is_file_valid = 0) THEN

								invalid_file_counter := invalid_file_counter + 1;

								dbms_output.put_line('count is '|| invalid_file_counter);
							END IF;
					  
					  		END;

					  	END LOOP;

					  	IF (invalid_file_counter = file_counter) THEN

								dbms_output.put_line('its invalid completely');
								
								/* 
								UPDATE INCONSISTENT_BLOCKS
								SET contains_files = 9
								WHERE INCONSISTENT_BLOCKS.dbs_block_id = rec_INCONSISTENT_BLOCKS.dbs_block_id;
								*/

								insert into invalid_dbs_blocks
									values(rec_INCONSISTENT_BLOCKS.dbs_block_id,file_counter,invalid_file_counter);
									commit;

							END IF;
					  	
					  	END;	

            
                
			  
			  END LOOP;

	  END;




END;  