set serveroutput on;

Create or REPLACE Procedure Consistency_verification IS
BEGIN

DECLARE

  -- row variable declaration for DBS Block table
 
  rec_dbs  cms_dbs3_prod_part.BLOCKS%ROWTYPE;
  
  -- row variable declaration for PhEDX Block table
  
  rec1_phedx  cms_transfermgmt_part.T_DPS_BLOCK%ROWTYPE;
  
  --consistency consition status variable
  
  is_consistent BOOLEAN;
 

  --file status information
  status varchar2(40);

  count_status number(1);
  size_status number(1);
  open_status number(1);
  open_status_phedx number(1);
  
  
BEGIN
     
     -- Looping through every DBS BLOCK record
     FOR rec_dbs IN (SELECT * FROM cms_dbs3_prod_part.blocks) LOOP
     
      BEGIN
      
      is_consistent := TRUE;
     
      open_status_phedx := 0;
      count_status:= 0;
      size_status := 0;
      open_status := 0;
      
      --dbms_output.put_line(rec_dbs.BLOCK_NAME || ' Found in DBS');
  
      SELECT * INTO rec1_phedx
      FROM CMS_TRANSFERMGMT_PART.T_DPS_BLOCK
      WHERE rec_dbs.BLOCK_NAME = cms_transfermgmt_part.T_DPS_BLOCK.NAME;
  
       --dbms_output.put_line( rec1_phedx.NAME|| ' Also found in PhEDX');

       
          
          IF (rec_dbs.BLOCK_SIZE != rec1_phedx.BYTES ) THEN 
          is_consistent :=FALSE;
          size_status:= 1; 
          END IF;


          IF (rec_dbs.FILE_COUNT != rec1_phedx.FILES ) THEN 
          is_consistent :=FALSE;
          count_status:= 1; 
          END IF;

          IF ((rec_dbs.OPEN_FOR_WRITING = 1 AND rec1_phedx.IS_OPEN = 'n') OR (rec_dbs.OPEN_FOR_WRITING = 0 AND rec1_phedx.IS_OPEN = 'y')) THEN 
          is_consistent := FALSE;
          open_status := 1;

          IF (rec1_phedx.IS_OPEN = 'y') THEN
          open_status_phedx := 1;
          END IF; 

          END IF;
          
          
                                 
       IF (NOT is_consistent) THEN
        --dbms_output.put_line(' NOT CONSISTENT');

        insert_inconsistent_block(rec_dbs.BLOCK_ID,rec1_phedx.ID,rec_dbs.BLOCK_SIZE,rec1_phedx.BYTES,rec_dbs.FILE_COUNT,rec1_phedx.FILES,rec_dbs.OPEN_FOR_WRITING,open_status_phedx,rec_dbs.DATASET_ID,rec1_phedx.DATASET,rec_dbs.BLOCK_NAME,rec1_phedx.NAME);--,size_status,count_status,open_status);

       
        --dbms_output.put_line('Number of inconsistencies '||counter ||' ');

       END IF; 




       -- Handles cases where a DBS block record is not found in PhEDX Block table
       

        EXCEPTION

        when NO_DATA_FOUND THEN
        
        -- Block not present in PhEDX
          insert_inconsistent_block(rec_dbs.BLOCK_ID,NULL,rec_dbs.BLOCK_SIZE,NULL,rec_dbs.FILE_COUNT,NULL,rec_dbs.OPEN_FOR_WRITING,NULL,rec_dbs.DATASET_ID,NULL,rec_dbs.BLOCK_NAME,NULL);
        

          CONTINUE;


          when TOO_MANY_ROWS THEN
          --dbms_output.put_line(' NOT CONSISTENT too many'); to be handled later
          
          continue;
       
       END;
       
    end loop;
    commit;

  
END;

END;
