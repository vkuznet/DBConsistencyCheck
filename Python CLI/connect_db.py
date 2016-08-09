#!/usr/bin/env Python
import cx_Oracle
import sys
import time
import argparse
import login



def connect():
    username = login.return_credentials()['username']
    password = login.return_credentials()['password']
    dbname   = login.return_credentials()['dbname']

    db = cx_Oracle.connect(username, password, dbname)
    cursor = db.cursor()
    return db, cursor


