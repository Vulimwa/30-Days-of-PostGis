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
-- ST_Distance and ST_DWithin
-- An extremely common GIS question is “find all the stuff within distance X of this other stuff”.
-- The ST_Distance(geometry A, geometry B) calculates the shortest distance between two geometries and returns it as a float.
SELECT ST_Distance(
  ST_GeometryFromText('POINT(0 5)'),
  ST_GeometryFromText('LINESTRING(-2 2, 2 2)'));

-- For testing whether two objects are within a distance of one another, the ST_DWithin function provides an 
-- index-accelerated true/false test. This is useful for questions like “how many trees are within a 500 meter buffer 
-- of the road?”. You don’t have to calculate an actual buffer, you just have to test the distance relationship.
-- Using our Broad Street subway station again, we can find the streets nearby (within 10 meters of) the subway stop:
SELECT name
FROM nyc_streets
WHERE ST_DWithin(
        geom,
        ST_GeomFromText('POINT(583571 4506714)',26918),
        10
      );
-- Function List
-- ST_Contains(geometry A, geometry B): Returns true if and only if no points of B lie in the exterior of A, and at least one point of the interior of B lies in the interior of A.
-- ST_Crosses(geometry A, geometry B): Returns TRUE if the supplied geometries have some, but not all, interior points in common.
-- ST_Disjoint(geometry A , geometry B): Returns TRUE if the Geometries do not “spatially intersect” - if they do not share any space together.
-- ST_Distance(geometry A, geometry B): Returns the 2-dimensional cartesian minimum distance (based on spatial ref) between two geometries in projected units.
-- ST_DWithin(geometry A, geometry B, radius): Returns true if the geometries are within the specified distance (radius) of one another.
-- ST_Equals(geometry A, geometry B): Returns true if the given geometries represent the same geometry. Directionality is ignored.
-- ST_Intersects(geometry A, geometry B): Returns TRUE if the Geometries/Geography “spatially intersect” - (share any portion of space) and FALSE if they don’t (they are Disjoint).
-- ST_Overlaps(geometry A, geometry B): Returns TRUE if the Geometries share space, are of the same dimension, but are not completely contained by each other.
-- ST_Touches(geometry A, geometry B): Returns TRUE if the geometries have at least one point in common, but their interiors do not intersect.
-- ST_Within(geometry A , geometry B): Returns true if the geometry A is completely inside geometry B