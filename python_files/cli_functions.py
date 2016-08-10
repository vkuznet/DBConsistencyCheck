#!/usr/bin/env python
#-*- coding: utf-8 -*-
"""
Contains functions that are used for cli parsing and response by verify_consistency.py

"""

import argparse
import time
import csv_gen

def parse_options():
	"Parse options and return arguments and parser objects"
	parser = argparse.ArgumentParser(description="Produces CSV document conatining details about inconsistent block and files. ")
	
	parser.add_argument("-f","--files",help="generates CSV document for inconsistent files ",action="store_true")
	parser.add_argument("-b","--blocks",help="generates CSV document for inconsistent blocks",action="store_true")
	parser.add_argument("-i","--invalid",help="generates CSV document for invalid blocks which contain only invalid files",action="store_true")
	parser.add_argument("-d","--dbs",help="generates CSV document contining DBS blocks/files",action="store_true")
	parser.add_argument("-p","--phedx",help="generates CSV document contining PhEDX blocks/files",action="store_true")
	parser.add_argument("-dp","--dbsphedx",help="generates CSV document contining both DBS and PhEDX blocks/files",action="store_true")
	parser.add_argument("-pd","--phedxdbs",help="generates CSV document contining both DBS and PhEDX blocks/files",action="store_true")
	parser.add_argument("-v","--verbose",help="prints row arrays to console as they are added to the CSV Document",action="store_true")
	parser.add_argument("csv_destination",nargs='?',default="./",help="Used to specify the destination of the produced CSV files.\n Default location is the current directory.")
	
	args = parser.parse_args()
	return args,parser

def generate_csv(table_name,verbosity_value,csv_file_location,output_limiter):
	"Create requested CSV and also print time taken"	
	start_time = time.time()

	if output_limiter == "none":
		print "Generating " + table_name + " CSV"
	else:
		print "Generating " + table_name + " CSV for " + output_limiter

	csv_gen.create_csv(table_name,verbosity_value,csv_file_location,output_limiter)

	print "Task completed in "+str(time.time()-start_time)+ " Seconds."

def respond_to_args(args):
	"call generate_csv with appropriate arguments based on arguments provided"

	if args.dbsphedx or args.phedxdbs:
		generate_csv("inconsistent_blocks",args.verbose,args.csv_destination,"none")
		generate_csv("inconsistent_files",args.verbose,args.csv_destination,"none")
		
	elif args.dbs:

		if args.blocks:
			generate_csv("inconsistent_blocks",args.verbose,args.csv_destination,"dbs")
			
		if args.files:
			generate_csv("inconsistent_files",args.verbose,args.csv_destination,"dbs")
			
		if (args.files and args.blocks) or ((not args.files) and (not args.blocks)) :
			generate_csv("inconsistent_blocks",args.verbose,args.csv_destination,"dbs")
			generate_csv("inconsistent_files",args.verbose,args.csv_destination,"dbs")
			
	elif args.phedx:

		if args.blocks:
			generate_csv("inconsistent_blocks",args.verbose,args.csv_destination,"phedx")
			
		if args.files:
			generate_csv("inconsistent_files",args.verbose,args.csv_destination,"phedx")
			
		if (args.files and args.blocks) or (not args.files and not args.blocks) :
			generate_csv("inconsistent_blocks",args.verbose,args.csv_destination,"phedx")
			generate_csv("inconsistent_files",args.verbose,args.csv_destination,"phedx")
			
	elif args.files:
		generate_csv("inconsistent_files",args.verbose,args.csv_destination,"dbs")
		generate_csv("inconsistent_files",args.verbose,args.csv_destination,"phedx")
		
	elif args.blocks:
		generate_csv("inconsistent_blocks",args.verbose,args.csv_destination,"dbs")
		generate_csv("inconsistent_blocks",args.verbose,args.csv_destination,"phedx")
		
	elif args.invalid:
		generate_csv("invalid_dbs_blocks",args.verbose,args.csv_destination,"none")

	else:
		generate_csv("inconsistent_blocks",args.verbose,args.csv_destination,"none")
		generate_csv("inconsistent_files",args.verbose,args.csv_destination,"none")