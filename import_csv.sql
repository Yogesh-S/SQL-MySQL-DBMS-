# *** Excel remove commas from the csv file

# create an empty table by importing csv using the wizard
CREATE TABLE films LIKE filmstemp;

#truncate if there are any rows
truncate films;

# to get the csv file uploading path
SHOW VARIABLES LIKE "secure_file_priv"; 

# upload the files to the same path or change secure_file_priv path
# and import using the command below
# check and include list of columns which have null values in the command
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/films.csv' IGNORE
INTO TABLE films
FIELDS TERMINATED BY ',' 
LINES TERMINATED BY '\n'  #***set \r\n if there are null values in the final column
IGNORE 1 LINES
SET release_year = NULLIF(release_year,''),
country = NULLIF(country,''),
duration = NULLIF(duration,''),
language = NULLIF(language,''),
certification = NULLIF(certification,''),
gross = NULLIF(gross,''),
budget= NULLIF(budget,'')
;