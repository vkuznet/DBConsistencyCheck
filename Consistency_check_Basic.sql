
set serveroutput on;

DECLARE


  -- row variable declaration for DBS Block table
 
  
  rec_dbs  cms_dbs3_prod_part.BLOCKS%ROWTYPE;
  
  -- row variable declaration for PhEDX Block table
  
  rec1_phedx  cms_transfermgmt_part.T_DPS_BLOCK%ROWTYPE;
  
  --consistency consition status variable
  
  is_consistent BOOLEAN;

  
  
BEGIN
     
     -- Looping through every DBS BLOCK record
     FOR rec_dbs IN (SELECT * FROM cms_dbs3_prod_part.blocks) LOOP
     
      BEGIN
      
      is_consistent := TRUE;
      
      dbms_output.put_line(rec_dbs.BLOCK_NAME || ' Found in DBS');
  
      SELECT * INTO rec1_phedx
      FROM CMS_TRANSFERMGMT_PART.T_DPS_BLOCK
      WHERE rec_dbs.BLOCK_NAME = cms_transfermgmt_part.T_DPS_BLOCK.NAME;
  
       dbms_output.put_line( rec1_phedx.NAME|| ' Also found in PhEDX');

       CASE
          
          WHEN (rec_dbs.BLOCK_SIZE != rec1_phedx.BYTES AND is_consistent) THEN is_consistent :=FALSE;
          WHEN (rec_dbs.FILE_COUNT != rec1_phedx.FILES AND is_consistent) THEN is_consistent :=FALSE;
          WHEN (is_consistent  AND ((rec_dbs.OPEN_FOR_WRITING = 1 AND rec1_phedx.IS_OPEN = 'n') OR (rec_dbs.OPEN_FOR_WRITING = 0 AND rec1_phedx.IS_OPEN = 'y')))
          THEN is_consistent :=FALSE;
          
          ELSE NULL;
       END CASE;
       
      /*
       IF (rec_dbs.BLOCK_SIZE != rec1_phedx.BYTES) THEN
        is_consistent :=FALSE;
       END IF;
       
       */
       IF (NOT is_consistent) THEN
        dbms_output.put_line(' NOT CONSISTENT');
       END IF; 


       -- Handles cases where a DBS block record is not found in PhEDX Block table 
        EXCEPTION
        when NO_DATA_FOUND THEN
          CONTINUE;
       
       END;
       
    end loop;

  
END;
