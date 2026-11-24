-- SPATIAL RELATIONSHIPS
--ST_Equals(geometry A, geometry B) tests the spatial equality of two geometries.
-- ST_Equals returns TRUE if two geometries of the same type have identical x,y coordinate values, i.e. if the second shape is equal (identical) to the first shape.
SELECT name, geom
FROM nyc_subway_stations
WHERE name = 'Broad St';

SELECT
	 name
FROM nyc_subway_stations
WHERE ST_Equals(geom, '0101000020266900000EEBD4CF27CF2141BC17D69516315141');

 -- ST_Intersects, ST_Disjoint, ST_Crosses and ST_Overlaps