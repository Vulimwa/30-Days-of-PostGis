-- INTRODUCTION TO POSTGIS
-- Enabling postgis extension
CREATE EXTENSION IF NOT EXISTS postgis;
-- Postgis version
SELECT postgis_full_version();

-- SRID-Spatial Reference Identifier-Projection-coordinates
SELECT srtext 
FROM spatial_ref_sys
WHERE srid=26918;


-- SQL BASICS
SELECT
	name
FROM nyc_neighborhoods;

-- SQL VERBS
-- SELECT, returns rows in response to a query
-- INSERT, adds new rows to a table
-- UPDATE, alters existing rows in a table
-- DELETE, removes rows from a table

-- FILTERS
SELECT name
FROM nyc_neighborhoods
WHERE boroname ='Brooklyn';

-- In postgres double quotes refer to object eg column