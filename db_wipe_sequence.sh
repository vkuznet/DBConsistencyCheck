sqlplus -s /nolog << EOF
CONNECT username/password;

whenever sqlerror exit sql.sqlcode;
set echo off 
set heading off

@db_wipe_sequence.sql

exit;
EOF
