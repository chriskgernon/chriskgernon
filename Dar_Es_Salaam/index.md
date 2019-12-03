I was interested in answering the question: which subwards are most at risk for drain blockages during floods?


Using data from the Resilience Academy and Ramani Huria, I analyzed the minimum average distance between drains and waste sites in each subward in Dar Es Salaam in order to offer an indication for which subwards are most likely to have drain blockages during flooding. We assumed that the closer a drain was to a waste site, the more likely it is for it to be blocked during flooding. 

I used OpenStreetMap data (from [this link](https://www.openstreetmap.org/#map=4/38.01/-95.84) collected through the Rumani Huria Project to analyze the spatial relationship between drains and waste sites in Dar es Salaam. PostGIS and the DB Manager of QGIS were used to find the average distance from drains to the nearest waste sites within a 50 m buffer by subward. Leaflet was used to visualize the output. The qgis2web plugin in QGIS allowed for the creation of the leaflet map.

[SQL Code](./waste&drains.sql/)

This chunk of code corrects the geometries for the subwards, wards, waste sites, and drain locations and reprojects 
the geometry into a projection that makes distance calculations more accurate for the Dar Es Salaam area.
```sql
/*Code written by Chris Gernon and Kufre Nkereuwem*/
/*Fixing geometries and reprojecting*/
create table wards37s as
select id, fid, ward_name,
st_makevalid(st_transform(geom,32737)) as geom
from wards;

create table subwards37s as
select fid,
st_transform(geom,32737) as geom
from subwards;

create table waste37s as
select id,
st_transform(geom, 32737) as geom
from waste;

create table drains37s as
select id,
st_transform(geom,32737) as geom
from drains;

select populate_geometry_columns();
```

This chunk of code assigns indices for each of the tables so that I can query the data faster. Indices are used
when indexing is required for a large amount of data. 

```sql
/*adding spatial indices*/
create index sidx_wards37s_geom
on wards37s
using GIST(geom);

create index sidx_subwards37s_geom
on subwards37s
using GIST(geom);

create index sidx_drains37s_geom
on drains37s
using GIST(geom);

create index sidx_waste37s_geom
on waste37s
using GIST(geom);
```
This chunk of code assigns each drain and waste site to a ward and subward. This step is necessary so that the distance between each drain and waste site can be calculated in each subward or ward. Without it, I would calculate the distance between each drain and waste site in all of Dar Es Salaam, which would not be useful. 

```sql
/*assigning drains and waste sites to wards and subwards*/
alter table drains37s add column ward text;

update drains37s
set ward=wards37s.ward_name
from wards37s
where st_intersects(drains37s.geom,wards37s.geom);

alter table drains37s add column subward float8;

update drains37s
set subward=subwards37s.fid
from subwards37s
where st_intersects(drains37s.geom,subwards37s.geom);

alter table waste37s add column ward text;

update waste37s
set ward=wards37s.ward_name
from wards37s
where st_intersects(waste37s.geom,wards37s.geom);


alter table waste37s add column subward float8;

update waste37s
set subward=subwards37s.fid
from subwards37s
where st_intersects(waste37s.geom,subwards37s.geom);
```

This chunk of code calculates the distace from each drain to each waste site that is within 50 meters of a drain. I use 50 meters as the criteria because it speeds up the calculation process, and it is unlikely that waste will clog a drain that is on the other side of a ward or subward.

```sql
/* finding distance from drains to waste sites*/
create table distfromdrain as
select drains37s.id as drains, waste37s.id as waste,
st_distance(geography(st_transform(drains37s.geom, 4326)), geography(st_transform(waste37s.geom, 4326))) as dist
from drains37s, waste37s
where st_intersects(st_buffer(drains37s.geom,50), waste37s.geom);
```
This chunk of code finds the minimum average distance between drains and waste sites in each subward and ward. 

```sql
/*finding minimum distance between drains and waste sites */
create table mindistfromdrain as
select drains, min(dist) as dist
from distfromdrain
group by drains;

/*averaging minimum distance for wards and subwards*/
create table wardminavg as
select b.ward, avg(dist)
from mindistfromdrain as a
left outer join drains37s as b
on a.drains=b.id
group by b.ward;


create table subwardminavg as
select b.subward, avg(dist)
from mindistfromdrain as a
left outer join drains37s as b
on a.drains=b.id
group by b.subward;

/*adding columns*/
alter table subwards37s
add column wastesites float8,
add column drains float8,
add column avgmindist float8;
```

This chunk of code counts the number of drains and waste sites in each subward then assigns the average minimum distance to the subwards table.

```sql
/*counting number of drains and waste sites in each subward*/
update subwards37s
set wastesites=(
select count(waste37s.id)
from waste37s
where subwards37s.fid=waste37s.subward);

update subwards37s
set drains=(
select count(drains37s.id)
from drains37s
where subwards37s.fid=drains37s.subward);

/*adding average minimum distance to subwards*/
update subwards37s
set avgmindist=subwardminavg.avg
from subwardminavg
where subwards37s.fid=subwardminavg.subward;

/*adding columns*/
alter table wards37s
add column wastesites float8,
add column drains float8,
add column avgmindist float8;
```
This chunk of code does the same as the chunk above but for wards.

```sql
/*counting number of drains and waste sites in each ward*/
update wards37s
set wastesites=(
select count(waste37s.id)
from waste37s
where wards37s.ward_name=waste37s.ward);

update wards37s
set drains=(
select count(drains37s.id)
from drains37s
where wards37s.ward_name=drains37s.ward);

/*adding average minimum distance to wards*/
update wards37s
set avgmindist=wardminavg.avg
from wardminavg
where wards37s.ward_name=wardminavg.ward;
```
Here is the result of our analysis! [Leaflet](./leaflet_final/qgis2web_2019_11_14-22_50_51_673447/index.html)
