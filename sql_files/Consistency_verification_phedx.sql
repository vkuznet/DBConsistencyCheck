-- =============================================
-- Author: Shubham Gupta 
-- Create date: 19.08.16
-- Description: Performs the same function as consistency_verification_2 but from PhEDEX's side.It iterates over BLOCKS 
-- in PhEDX's T_DPS_BLOCk trying to find the same block in DBS's table of blocks.If the PhEDEX Block is also found in DBS then
-- the procedure moves on to the next block, it does not perform parameter checking processes as that is already handled by 
-- the consistency_verification_2 and if blocks of PhEDEX are present in DBS then their parameters are assumed to have been 
-- checked and handled by the other procedure.This procedure Just detects absence of PhEDX blocks in DBS.
-- =============================================
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
