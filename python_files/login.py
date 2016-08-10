#!/usr/bin/env python
#-*- coding: utf-8 -*-
"""
Returns Login credentials.

"""

def return_credentials():
	"Provide login credentials to connect_db.py"
	credentials = {
		'username' : 'cms_dbs_tranf_ver',
		'password' : '',
		'dbname' : 'int2r' 
	}
	return credentials

if __name__ == "__main__":
	return_credentials()