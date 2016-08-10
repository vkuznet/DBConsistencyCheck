#!/usr/bin/env python
#-*- coding: utf-8 -*-
"""
Uses functions in cli_functions module to parse cli options and respond to them.
 
"""

import cli_functions

def main():
	"Main function"

	args,parser = cli_functions.parse_options()

	cli_functions.respond_to_args(args)

if __name__ == "__main__":
	main()	




