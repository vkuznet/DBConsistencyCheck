def rearrange(row):
	
	another_row = []
	# row id,database,block_name,number_of_files,Size,state,id,database,block_name,number_of_files,Size,state
	
	another_row.append(row[1]) #dbs id
	another_row.append(row[-4])
	another_row.append(row[-2])
	another_row.append(row[6])
	another_row.append(row[4])
	another_row.append(row[8])
	another_row.append(row[2])
	another_row.append(row[-3])
	another_row.append(row[-1])
	another_row.append(row[7])
	another_row.append(row[5])
	another_row.append(row[9])
	 
	return another_row

def generate_header(cursor):
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