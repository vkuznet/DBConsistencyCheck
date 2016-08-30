-- =============================================
-- Author: Shubham Gupta 
-- Create date: 19.08.16
-- Description: Phedex and DBS store checksums in different ways. While DBS has seperate fields for each type of checksum, 
-- Phedex stores all checksume in a single field as a set of key value pairs.
-- This procedure takes the string of key value pairs of phedex checksums as input and provides output in the form of Adler32 
-- and Checksum.These values are then used for comparison of files between DBS and PhEDEX.
-- =============================================

create or replace Procedure checksum_parser_phedx( input_checksum_string in varchar2, adler32_value out varchar2, cksum_value out varchar2) is
BEGIN

DECLARE



  	comma_pos Number := Instr(input_checksum_string, ',' );
  	colon_pos Number := Instr(input_checksum_string, ':' );
    colon_pos_2 Number := Instr(input_checksum_string, ':',1,2 );

    
BEGIN
    
    IF (comma_pos != 0) THEN
    	IF(SUBSTR(input_checksum_string,1,colon_pos-1) = 'adler32' and SUBSTR(input_checksum_string,comma_pos+1,colon_pos_2-comma_pos-1) = 'cksum') THEN

    		adler32_value := SUBSTR(input_checksum_string,colon_pos+1,comma_pos-colon_pos-1);
    		cksum_value	:= SUBSTR(input_checksum_string,colon_pos_2+1);
    		
        dbms_output.put_line('checksum is ' || adler32_value || cksum_value);

    	END IF;	

    END IF;

    IF (comma_pos = 0) THEN

	  	IF (colon_pos != 0 and SUBSTR(input_checksum_string,1,colon_pos-1) = 'adler32') THEN
	  	
	  		
	  		adler32_value := SUBSTR(input_checksum_string,colon_pos+1);
        cksum_value := 0;
	  		dbms_output.put_line('checksum is ' || adler32_value );
	    
	    END IF;

	    IF (colon_pos != 0 and SUBSTR(input_checksum_string,1,colon_pos-1) = 'cksum') THEN
	  	
	  		cksum_value := SUBSTR(input_checksum_string,colon_pos+1);
        adler32_value := 0;
	    	dbms_output.put_line('checksum is ' || cksum_value );


	    END IF;
	END IF;      
	      
	    END;
       
END;
/

