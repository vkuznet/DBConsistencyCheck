#!/usr/bin/env python
#-*- coding: utf-8 -*-
"""
Contains functions that assist in CSV file creation.

"""

def rearrange(row):
	"Rearrange contents of inconsistent_blocks table's rows to match CSV format"
	rearranged_row = []
	#id,database,block_name,number_of_files,Size,state,id,database,block_name,number_of_files,Size,state
	
	rearranged_row.append(row[1]) 
	rearranged_row.append(row[-4])
	rearranged_row.append(row[-2])
	rearranged_row.append(row[6])
	rearranged_row.append(row[4])
	rearranged_row.append(row[8])
	rearranged_row.append(row[2])
	rearranged_row.append(row[-3])
	rearranged_row.append(row[-1])
	rearranged_row.append(row[7])
	rearranged_row.append(row[5])
	rearranged_row.append(row[9])
	 
	return rearranged_row

def generate_header(cursor):
	"Generate CSV file header according to the rearranged row's Format using cursor description"
	top_row = []

	top_row.append(cursor.description[1][0]) 
	top_row.append(cursor.description[-4][0])
	top_row.append(cursor.description[-2][0])
	top_row.append(cursor.description[6][0])
	top_row.append(cursor.description[4][0])
	top_row.append(cursor.description[8][0])
	top_row.append(cursor.description[2][0])
	top_row.append(cursor.description[-3][0])
	top_row.append(cursor.description[-1][0])
	top_row.append(cursor.description[7][0])
	top_row.append(cursor.description[5][0])
	top_row.append(cursor.description[9][0])
    
	return top_row

def assign_sql(table_name,output_limiter):
	"Assign SQL statement for cursor to execute based on options selected"

	sql_container=["SELECT * FROM " + str(table_name),"SELECT * FROM " + str(table_name)+" where phedx_block_id is NULL ","SELECT * FROM " + str(table_name)+" where dbs_block_id is NULL","SELECT * FROM " + str(table_name)+" where block_id_phedx is NULL","SELECT * FROM " + str(table_name)+" where block_id_dbs is NULL"]
	 
	if output_limiter == "none":
		SQL= sql_container[0]

	elif output_limiter == "dbs" and table_name == "inconsistent_blocks":
		SQL = sql_container[1]

	elif output_limiter == "phedx" and table_name == "inconsistent_blocks":
		SQL = sql_container[2] 

	elif output_limiter == "dbs" and table_name == "inconsistent_files":
		SQL = sql_container[3] 

	elif output_limiter == "phedx" and table_name == "inconsistent_files":
		SQL = sql_container[4] 

	return SQL		