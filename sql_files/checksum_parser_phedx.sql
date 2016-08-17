

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

    --If Block For single Checksum type processing
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

