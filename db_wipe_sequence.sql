--WARNING : Execute only f you're sure about what you're doing
truncate table inconsistent_blocks;
truncate table inconsistent_files;
truncate table invalid_dbs_blocks;
drop table INCONSISTENT_BLOCKS;
drop table INCONSISTENT_FILES;
drop table invalid_dbs_blocks;
drop SEQUENCE block_sequence;
drop SEQUENCE file_sequence;
drop TRIGGER blocks_on_insert;
drop TRIGGER files_on_insert;

