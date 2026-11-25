-- sum(expression) aggregate to return a sum for a set of records
-- count(expression) aggregate to return the size of a set of records
-- ST_Contains(geometry A, geometry B) returns true if geometry A contains geometry B
-- ST_Crosses(geometry A, geometry B) returns true if geometry A crosses geometry B
-- ST_Disjoint(geometry A , geometry B) returns true if the geometries do not “spatially intersect”
-- ST_Distance(geometry A, geometry B) returns the minimum distance between geometry A and geometry B
-- ST_DWithin(geometry A, geometry B, radius) returns true if geometry A is radius distance or less from geometry B
-- ST_Equals(geometry A, geometry B) returns true if geometry A is the same as geometry B
-- ST_Intersects(geometry A, geometry B) returns true if geometry A intersects geometry B
-- ST_Overlaps(geometry A, geometry B) returns true if geometry A and geometry B share space, but are not completely contained by each other.
-- ST_Touches(geometry A, geometry B) returns true if the boundary of geometry A touches geometry B
-- ST_Within(geometry A, geometry B) returns true if geometry A is within geometry B

-- Questions
-- What is the geometry value for the street named ‘Atlantic Commons’?
SELECT 
	ST_AsTexT(geom)
FROM nyc_streets
WHERE name='Atlantic Commons';

-- What neighborhood and borough is Atlantic Commons in?
SELECT
	name,
	boroname
FROM nyc_neighborhoods
WHERE ST_Intersects(
					geom,
					ST_GeomFromText('MULTILINESTRING((586781.7015777241 4504202.153143394,586863.5196448397 4504215.988170098))',26918));

-- OR
SELECT n.name, n.boroname
FROM nyc_neighborhoods AS n
JOIN nyc_streets AS s
  ON ST_Intersects(n.geom, s.geom)
WHERE s.name = 'Atlantic Commons';

-- What streets does Atlantic Commons join with?
SELECT s.name
FROM nyc_streets AS s
JOIN nyc_streets AS ac
  ON ST_DWithin(s.geom, ac.geom, 0.1)
WHERE ac.name = 'Atlantic Commons'
  AND s.gid <> ac.gid;
