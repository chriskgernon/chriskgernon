/* Add a pojected coordinate system to PostGIS database */
INSERT into spatial_ref_sys (srid, auth_name, auth_srid, proj4text, srtext) values ( 102004, 'esri', 102004, '+proj=lcc +lat_1=33 +lat_2=45 +lat_0=39 +lon_0=-96 +x_0=0 +y_0=0 +ellps=GRS80 +datum=NAD83 +units=m +no_defs ', 'PROJCS["USA_Contiguous_Lambert_Conformal_Conic",GEOGCS["GCS_North_American_1983",DATUM["North_American_Datum_1983",SPHEROID["GRS_1980",6378137,298.257222101]],PRIMEM["Greenwich",0],UNIT["Degree",0.017453292519943295]],PROJECTION["Lambert_Conformal_Conic_2SP"],PARAMETER["False_Easting",0],PARAMETER["False_Northing",0],PARAMETER["Central_Meridian",-96],PARAMETER["Standard_Parallel_1",33],PARAMETER["Standard_Parallel_2",45],PARAMETER["Latitude_Of_Origin",39],UNIT["Meter",1],AUTHORITY["EPSG","102004"]]');

select * from spatial_ref_sys where srid = 102004;

/* add geom column*/
SELECT AddGeometryColumn('public','dorian', 'geom3',  102004, 'POINT', 2);

SELECT AddGeometryColumn('public','november', 'geom3',  102004, 'POINT', 2);


/* transform geom column*/
UPDATE dorian
SET geom3 = st_transform( st_setsrid( st_makepoint(lng,lat),4326), 102004);

UPDATE november
SET geom3 = st_transform( st_setsrid( st_makepoint(lng,lat),4326), 102004);

UPDATE counties SET geometry = st_transform(geometry,102004);

SELECT populate_geometry_columns('counties':: regclass);

/* getting rid of the counties we do not need */
DELETE FROM counties
WHERE "STATEFP" NOT IN ('54', '51', '50', '47', '45', '44', '42', '39', '37',
'36', '34', '33', '29', '28', '25', '24', '23', '22', '21', '18', '17',
'13', '12', '11', '10', '09', '05', '01');


/* count the number of each typpe of tweet by county*/
ALTER TABLE november ADD COLUMN geoid varchar(5);


UPDATE november
SET geoid = "GEOID"
FROM counties2
WHERE st_intersects(counties2.geometry, november.geom3);

UPDATE dorian
SET geoid = "GEOID"
FROM counties2
WHERE st_intersects(counties2.geometry, dorian.geom3);

/* Group twitter layers while counting the number of tweets*/
CREATE TABLE novembercounts AS
SELECT geoid, count(november.geoid) 
FROM november
group by november.geoid;

CREATE TABLE doriancounts AS
SELECT geoid, count(dorian.geoid)  as count
FROM dorian
group by dorian.geoid;

/* add columns */
ALTER TABLE counties2 ADD COLUMN dorian_tweets int;

ALTER TABLE counties2 ADD COLUMN november_tweets int;

UPDATE counties2
SET dorian_tweets = 0;

UPDATE counties2
SET november_tweets = 0;

UPDATE counties2
SET dorian_tweets = count
FROM doriancounts
WHERE doriancounts.geoid = counties2."GEOID";


UPDATE counties2
SET november_tweets = count
FROM novembercounts
WHERE novembercounts.geoid = counties2."GEOID";

ALTER TABLE counties2 ADD COLUMN tweet_rate real;

UPDATE counties2
SET tweet_rate = (1*1.000000)*(dorian_tweets/"POP") * 10000;


ALTER TABLE counties2 ADD COLUMN ndti real;

UPDATE counties2
SET ndti = (1*1.0000)*(dorian_tweets- november_tweets)/(dorian_tweets + november_tweets) *(1*1.0000)
where dorian_tweets + november_tweets >0;