-- Creating a table
-- GEOMETRIES
CREATE TABLE geo_geometries(
name varchar(100),
geom geometry
);
-- Adding data
INSERT INTO geo_geometries VALUES
('Point','POINT(0 0)'),
('Line','LINESTRING(0 0,1 1,0 1)'),
('Polygon','POLYGON((0 3, 4 3, 2 3, 0 3))'),
('Polygonwithahole','POLYGON((0 3, 4 3, 2 3, 0 3),(4 3, 2 3, 6 3, 4 3))'),
('Colection','GEOMETRYCOLLECTION(POINT(2 0),POLYGON((0 0, 1 0, 1 1, 0 1, 0 0)))');

SELECT 
	ST_AsText(geom) as geometry_text,
	ST_GeometryType(geom) as geometry_type,
	ST_NDims(geom) as geom_dimensions,
	ST_SRID(geom) as spatial_reference
FROM geo_geometries;

-- ST_X(geometry) returns the X ordinate
-- ST_Y(geometry) returns the Y ordinate

-- Reading X and Y of a point
SELECT 
 ST_X(geom) as X_ordinate,
 ST_Y(geom) as Y_ordinate
FROM geo_geometries
WHERE name='Point' or ST_GeometryType(geom)='ST_Point';

-- SPATIAL FUNCTIONS OF WORKING WITH STRINGS
-- ST_Length(geometry) returns the length of the linestring
-- ST_StartPoint(geometry) returns the first coordinate as a point
-- ST_EndPoint(geometry) returns the last coordinate as a point
-- ST_NPoints(geometry) returns the number of coordinates in the linestring

SELECT 
	ROUND(ST_Length(geom)::numeric,2) as line_length, -- or ROUND(CAST(ST_Length(geom) AS NUMERIC),2)
	ST_AsText(ST_StartPoint(geom)) as first_coord,
	ST_AsText(ST_EndPoint(geom)) as last_coord,
	ST_NPoints(geom) as no_coordinates
FROM geo_geometries
WHERE name ='Line' OR ST_GeometryType(geom)='ST_Line';

-- POLYGONS
SELECT 
	ST_AsText(geom)
FROM geo_geometries
WHERE name LIKE '%Polygon%';

-- Some of the specific spatial functions for working with polygons are:
-- ST_Area(geometry) returns the area of the polygons
-- ST_NRings(geometry) returns the number of rings (usually 1, more if there are holes)
-- ST_ExteriorRing(geometry) returns the outer ring as a linestring
-- ST_InteriorRingN(geometry,n) returns a specified interior ring as a linestring
-- ST_Perimeter(geometry) returns the length of all the rings
-- CALCULATING AREA AND PERIMETER
SELECT 
	ROUND(ST_Area(geom)::numeric,4) as Area,
	ST_Perimeter(geom) as Perimeter
FROM geo_geometries
WHERE ST_GeometryType(geom)='ST_Polygon' or name LIKE '%Polygon%';

-- COLLECTIONS
-- MultiPoint, a collection of points
-- MultiLineString, a collection of linestrings
-- MultiPolygon, a collection of polygons
-- GeometryCollection, a heterogeneous collection of any geometry (including other collections)
SELECT 
	ST_AsText(geom)
FROM geo_geometries
WHERE ST_GeometryType(geom)='ST_GeometryCollection' OR name LIKE '%Colection%';

-- Some of the specific spatial functions for working with collections are:
-- ST_NumGeometries(geometry) returns the number of parts in the collection
-- ST_GeometryN(geometry,n) returns the specified part
-- ST_Area(geometry) returns the total area of all polygonal parts
-- ST_Length(geometry) returns the total length of all linear parts

SELECT 
	ST_NumGeometries(geom) AS collection_num,
	ST_AsText(ST_GeometryN(geom,2)) AS specified_collection,
	ST_Area(geom) AS total_area,
	ST_Length(geom) AS total_length
FROM geo_geometries
WHERE ST_GeometryType(geom)='ST_GeometryCollection';


-- Geometry Input and Output
-- Within the database, geometries are stored on disk in a format only used by the PostGIS program. In order for external programs to insert and retrieve useful geometries, they need to be converted into a format that other applications can understand. Fortunately, PostGIS supports emitting and consuming geometries in a large number of formats:

-- Well-known text (WKT)
-- ST_GeomFromText(text, srid) returns geometry
-- ST_AsText(geometry) returns text
-- ST_AsEWKT(geometry) returns text

-- Well-known binary (WKB)
-- ST_GeomFromWKB(bytea) returns geometry
-- ST_AsBinary(geometry) returns bytea
-- ST_AsEWKB(geometry) returns bytea


-- Geographic Mark-up Language (GML)
-- ST_GeomFromGML(text) returns geometry
-- ST_AsGML(geometry) returns text
-- Keyhole Mark-up Language (KML)
-- ST_GeomFromKML(text) returns geometry
-- ST_AsKML(geometry) returns text

-- GeoJSON
-- ST_AsGeoJSON(geometry) returns text
-- Scalable Vector Graphics (SVG)
-- ST_AsSVG(geometry) returns text
-- The most common use of a constructor is to turn a text representation of a geometry into an internal representation:

-- In addition to the ST_GeometryFromText function, there are many other ways to create geometries from well-known text or similar formatted inputs:

-- Using ST_GeomFromText with the SRID parameter
SELECT ST_GeomFromText('POINT(2 2)',4326);

-- Using ST_GeomFromText without the SRID parameter
SELECT ST_SetSRID(ST_GeomFromText('POINT(2 2)'),4326);

-- Using a ST_Make* function
SELECT ST_SetSRID(ST_MakePoint(2, 2), 4326);

-- Using PostgreSQL casting syntax and ISO WKT
SELECT ST_SetSRID('POINT(2 2)'::geometry, 4326);

-- Using PostgreSQL casting syntax and extended WKT
SELECT 'SRID=4326;POINT(2 2)'::geometry;
-- In addition to emitters for the various forms (WKT, WKB, GML, KML, JSON, SVG), PostGIS also has consumers for four (WKT, WKB, GML, KML). Most applications use the WKT or WKB geometry creation functions, but the others work too. Here’s an example that consumes GML and output JSON:


-- FUNCTION LIST
-- ST_Area: Returns the area of the surface if it is a polygon or multi-polygon. For “geometry” type area is in SRID units. For “geography” area is in square meters.
-- ST_AsText: Returns the Well-Known Text (WKT) representation of the geometry/geography without SRID metadata.
-- ST_AsBinary: Returns the Well-Known Binary (WKB) representation of the geometry/geography without SRID meta data.
-- ST_EndPoint: Returns the last point of a LINESTRING geometry as a POINT.
-- ST_AsEWKB: Returns the Well-Known Binary (WKB) representation of the geometry with SRID meta data.
-- ST_AsEWKT: Returns the Well-Known Text (WKT) representation of the geometry with SRID meta data.
-- ST_AsGeoJSON: Returns the geometry as a GeoJSON element.
-- ST_AsGML: Returns the geometry as a GML version 2 or 3 element.
-- ST_AsKML: Returns the geometry as a KML element. Several variants. Default version=2, default precision=15.
-- ST_AsSVG: Returns a Geometry in SVG path data given a geometry or geography object.
-- ST_ExteriorRing: Returns a line string representing the exterior ring of the POLYGON geometry. Return NULL if the geometry is not a polygon. Will not work with MULTIPOLYGON
-- ST_GeometryN: Returns the 1-based Nth geometry if the geometry is a GEOMETRYCOLLECTION, MULTIPOINT, MULTILINESTRING, MULTICURVE or MULTIPOLYGON. Otherwise, return NULL.
-- ST_GeomFromGML: Takes as input GML representation of geometry and outputs a PostGIS geometry object.
-- ST_GeomFromKML: Takes as input KML representation of geometry and outputs a PostGIS geometry object
-- ST_GeomFromText: Returns a specified ST_Geometry value from Well-Known Text representation (WKT).
-- ST_GeomFromWKB: Creates a geometry instance from a Well-Known Binary geometry representation (WKB) and optional SRID.
-- ST_GeometryType: Returns the geometry type of the ST_Geometry value.
-- ST_InteriorRingN: Returns the Nth interior linestring ring of the polygon geometry. Return NULL if the geometry is not a polygon or the given N is out of range.
-- ST_Length: Returns the 2d length of the geometry if it is a linestring or multilinestring. geometry are in units of spatial reference and geography are in meters (default spheroid)
-- ST_NDims: Returns coordinate dimension of the geometry as a small int. Values are: 2,3 or 4.
-- ST_NPoints: Returns the number of points (vertexes) in a geometry.
-- ST_NRings: If the geometry is a polygon or multi-polygon returns the number of rings.
-- ST_NumGeometries: If geometry is a GEOMETRYCOLLECTION (or MULTI*) returns the number of geometries, otherwise return NULL.
-- ST_Perimeter: Returns the length measurement of the boundary of an ST_Surface or ST_MultiSurface value. (Polygon, Multipolygon)
-- ST_SRID: Returns the spatial reference identifier for the ST_Geometry as defined in spatial_ref_sys table.
-- ST_StartPoint: Returns the first point of a LINESTRING geometry as a POINT.
-- ST_X: Returns the X coordinate of the point, or NULL if not available. Input must be a point.
-- ST_Y: Returns the Y coordinate of the point, or NULL if not available. Input must be a point.