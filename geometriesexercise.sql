-- EXECERCISES
-- What is the area of the ‘West Village’ neighborhood?
SELECT 
	ROUND(ST_Area(geom)::numeric,2) AS area
FROM nyc_neighborhoods
WHERE name='West Village';
-- What is the geometry type of ‘Pelham St’? The length?
SELECT 
	ST_GeometryType(geom) AS geomtype,
	ST_Length(geom) AS geom_length
FROM nyc_streets
WHERE name='Pelham St';

-- What is the GeoJSON representation of the ‘Broad St’ subway station?
SELECT 
	ST_AsGeoJSON(geom)
FROM nyc_subway_stations
WHERE name ='Broad St';

-- What is the total length of streets (in kilometers) in New York City?
SELECT 
	SUM(ST_Length(geom))/1000 AS total_length_km
FROM nyc_streets;
-- What is the area of Manhattan in acres?
SELECT
	SUM(ST_Area(geom))/4047 AS area_acres
FROM nyc_census_blocks
WHERE boroname='Manhattan';

-- What is the most westerly subway station?
SELECT 
	ST_X(geom),
	name
FROM nyc_subway_stations
ORDER BY ST_X(geom)
LIMIT 1;

-- How long is ‘Columbus Cir’ (aka Columbus Circle)?
SELECT 
	ST_Length(geom) as len
FROM nyc_streets
WHERE name='Columbus Cir';

-- What is the length of streets in New York City, summarized by type?
SELECT 
	type,
	SUM(ST_Length(geom)) AS len
FROM nyc_streets
GROUP BY type
ORDER BY SUM(ST_Length(geom)) DESC;
