cd sql_files/
cat table_create.sql checksum_parser_phedx.sql insert_inconsistent_block_proceure.sql insert_inconsistent_file.sql Wipe_tables.sql file_level_verification.sql file_level_verification_phedx.sql file_level_invalidation.sql file_level_DRIVER.sql consistency_verification_2.sql Consistency_verification_phedx.sql Verify_consistency_sequence.sql > ../install_script.sql
cd ..
 
sqlplus -s /nolog << EOF
CONNECT dbname/password;

whenever sqlerror exit sql.sqlcode;
set echo off 
set heading off

@install_script.sql

exit;
rm install_script.sql
EOF
