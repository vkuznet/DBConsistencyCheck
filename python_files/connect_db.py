#!/usr/bin/env python
#-*- coding: utf-8 -*-
"""
Establish connection to DB

"""
import cx_Oracle
import sys
import time
import argparse
import login



def connect():
    "connect to DB using credentials from login.py"
    username = login.return_credentials()['username']
    password = login.return_credentials()['password']
    dbname   = login.return_credentials()['dbname']

    try:
    	db = cx_Oracle.connect(username, password, dbname)
    	cursor = db.cursor()
    	return db, cursor
    except:
    	print "Unable to establish connection with Database.\nPlease verify your credentials and retry. "	


if __name__ == "__main__":
	connect()
    