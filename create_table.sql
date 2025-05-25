-- Create table

DROP TABLE IF EXISTS netflix;
CREATE TABLE netflix
(
	show_id	VARCHAR(5),
	type    VARCHAR(10),
	title	VARCHAR(250),
	director TEXT,
	casts	TEXT,
	country	TEXT,
	date_added	DATE,
	release_year	INT,
	rating	VARCHAR(15),
	duration	VARCHAR(15),
	listed_in	VARCHAR(250),
	description TEXT
);

SELECT * FROM netflix;