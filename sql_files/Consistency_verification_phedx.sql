set serveroutput on;

Create or REPLACE Procedure Consistency_verification_phedx IS
BEGIN

DECLARE

  -- row variable declaration for DBS Block table
 
  rec_dbs  cms_dbs3_prod_part.BLOCKS%ROWTYPE;
  
  -- row variable declaration for PhEDX Block table
  
  rec1_phedx  cms_transfermgmt_part.T_DPS_BLOCK%ROWTYPE;


  
  --open/close status variable
  
  mismatch_value Number(1);
  
  
BEGIN
     
     
     FOR rec1_phedx IN (SELECT * FROM cms_transfermgmt_part.T_DPS_BLOCK) LOOP
     
      BEGIN
      
      
      
      
  
      SELECT * INTO rec_dbs
      FROM cms_dbs3_prod_part.BLOCKS
      WHERE cms_dbs3_prod_part.BLOCKS.BLOCK_NAME = rec1_phedx.NAME;
  
       

       
        EXCEPTION

        when NO_DATA_FOUND THEN
        
        -- Block not present in DBS

        IF (rec1_phedx.is_open = 'y') THEN

        mismatch_value := 1;

        ELSE

        mismatch_value := 0;

        END IF;
          


          insert_inconsistent_block(NULL,rec1_phedx.ID,NULL,rec1_phedx.BYTES,NULL,rec1_phedx.FILES,NULL,mismatch_value,NULL,rec1_phedx.DATASET,null,rec1_phedx.NAME );
        

          CONTINUE;


         
       
       END;
       
    end loop;
    commit;

  
END;

END;
/
