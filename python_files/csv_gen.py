#!/usr/bin/env python
#-*- coding: utf-8 -*-
"""
create formatted CSV files using create_csv function.

"""

import cx_Oracle
import csv
import os
import connect_db
from csv_functions import rearrange
from csv_functions import generate_header
from csv_functions import assign_sql

def create_csv(table_name,verbosity,file_location="./",output_limiter="none"):
	"create formatted CSV file based on arguments provided "

	SQL = assign_sql(table_name,output_limiter)

	if output_limiter == "none":
		filename=  str(table_name) +".csv"
	else :
		filename=  str(table_name) +'_'+ output_limiter +".csv"	
	
	try:
		os.chdir(file_location)
	except :
		print "Directory Does not exist \n Creating directory"
		os.makedirs(file_location,0777)
		os.chdir(file_location)	

	FILE=open(filename,"w");
	output=csv.writer(FILE)

	connection, cursor = connect_db.connect()
	cursor.execute("select count(*) from "+ str(table_name))
	Number_of_records = cursor.fetchone()[0]


	cursor.execute(SQL)
	#print Number_of_records
	
	
	if table_name == "inconsistent_blocks":
		output.writerow(generate_header(cursor))

		output.writerow(["# Rows in this document:" + str( Number_of_records) ])
		
		if verbosity:
			for row in cursor:
				row = rearrange(row)
				print row
				output.writerow(row)
		else:
		
			for row in cursor:
				row = rearrange(row)
				output.writerow(row)
			
	    

	elif table_name == "inconsistent_files":
		
		file_header = []
		
		for i in range(1,11):
			file_header.append(cursor.description[i][0])
		output.writerow(file_header)
		
		output.writerow(["# Rows in this document: " + str( Number_of_records) ])
		
		if verbosity == True:
			for row in cursor:
				print row
				output.writerow(row[1:])
		else:
		
			for row in cursor:
				output.writerow(row[1:])
		
	elif table_name == "invalid_dbs_blocks":

		file_header = []
		
		for i in range(0,4):
			file_header.append(cursor.description[i][0])
		output.writerow(file_header)
		
		output.writerow(["# Rows in this document: " + str( Number_of_records) ])
		
		if verbosity == True:
			for row in cursor:
				print row[:-1]
				output.writerow(row[:-1])
		else:
		
			for row in cursor:
				output.writerow(row[:-1])

	else:
		for row in cursor:
			
			print row
			output.writerow(row)
    	
	cursor.close()
	connection.close()
	FILE.close()

def main():
	"Main function"
	create_csv('inconsistent_blocks',False,"./","none")
	create_csv('inconsistent_files',False,"./","none")

if __name__ == "__main__":
	main()