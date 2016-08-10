#!/usr/bin/python
import argparse
import csv_gen
import time

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

if args.dbsphedx or args.phedxdbs:
	
	start_time = time.time()
	print "Generating inconsistent blocks CSV"
	csv_gen.create_csv("inconsistent_blocks",args.verbose,args.csv_destination,"none")
	print "Task completed in "+str(time.time()-start_time)+ " Seconds."

	start_time = time.time()
	print "Generating inconsistent Files CSV"
	csv_gen.create_csv("inconsistent_files",args.verbose,args.csv_destination,"none")
	print "Task completed in "+str(time.time()-start_time)+ " Seconds."

elif args.dbs:

	if args.blocks:
		start_time = time.time()
		print "Generating inconsistent blocks CSV for DBS"
		csv_gen.create_csv("inconsistent_blocks",args.verbose,args.csv_destination,"dbs")
		print "Task completed in "+str(time.time()-start_time)+ " Seconds."

	if args.files:
		start_time = time.time()
		print "Generating inconsistent files CSV for DBS"
		csv_gen.create_csv("inconsistent_files",args.verbose,args.csv_destination,"dbs")
		print "Task completed in "+str(time.time()-start_time)+ " Seconds."

	if (args.files and args.blocks) or ((not args.files) and (not args.blocks)) :
		start_time = time.time()
		print "Generating inconsistent blocks CSV for DBS"
		csv_gen.create_csv("inconsistent_blocks",args.verbose,args.csv_destination,"dbs")
		print "Task completed in "+str(time.time()-start_time)+ " Seconds."

		start_time = time.time()
		print "Generating inconsistent files CSV for DBS"
		csv_gen.create_csv("inconsistent_files",args.verbose,args.csv_destination,"dbs")
		print "Task completed in "+str(time.time()-start_time)+ " Seconds."



elif args.phedx:

	if args.blocks:
		start_time = time.time()
		print "Generating inconsistent blocks CSV for PhEDX"
		csv_gen.create_csv("inconsistent_blocks",args.verbose,args.csv_destination,"phedx")
		print "Task completed in "+str(time.time()-start_time)+ " Seconds."

	if args.files:
		start_time = time.time()
		print "Generating inconsistent files CSV for PhEDX"
		csv_gen.create_csv("inconsistent_files",args.verbose,args.csv_destination,"phedx")
		print "Task completed in "+str(time.time()-start_time)+ " Seconds."

	if (args.files and args.blocks) or (not args.files and not args.blocks) :
		start_time = time.time()
		print "Generating inconsistent blocks CSV for PhEDX"
		csv_gen.create_csv("inconsistent_blocks",args.verbose,args.csv_destination,"phedx")
		print "Task completed in "+str(time.time()-start_time)+ " Seconds."	

		start_time = time.time()
		print "Generating inconsistent files CSV for PhEDX"
		csv_gen.create_csv("inconsistent_files",args.verbose,args.csv_destination,"phedx")
		print "Task completed in "+str(time.time()-start_time)+ " Seconds."


elif args.invalid:
	start_time = time.time()
	print "Generating invalid blocks CSV"
	csv_gen.create_csv("invalid_dbs_blocks",args.verbose,args.csv_destination,"none")
	print "Task completed in "+str(time.time()-start_time)+ " Seconds."

else:
	start_time = time.time()
	print "Generating inconsistent blocks CSV"
	csv_gen.create_csv("inconsistent_blocks",args.verbose,args.csv_destination,"none")
	print "Task completed in "+str(time.time()-start_time)+ " Seconds."

	start_time = time.time()
	print "Generating inconsistent Files CSV"
	csv_gen.create_csv("inconsistent_files",args.verbose,args.csv_destination,"none")
	print "Task completed in "+str(time.time()-start_time)+ " Seconds."












