## My First QGIS Model

Background: 

I am Chris Gernon, a junior at Middlebury College. I am taking a class that focuses on the open source element of GIS and other open source programs.

The discourse surrounding GIS is one of great concern for me. GIS is a contradictory technology that simultaneously marginalizes and empowers people and community members (Seiber 2007). Many view GIS and the work done using GIS as objective and factual. In reality, work done with GIS is incredibly subjective and bias. Because you download shapefiles and other data types from the internet that include neat rows and columns of data, it is easy to forget that a human was the one that collected and made the data. Thus, no data collection process is value free.

Many educators, hiring committees, or learning material frame GIS as a solution to many of the world’s problems (Wing and Martin, 2007). However, not all problems can or should be answered using a GIS. Classrooms, hiring committees, and textbooks a one-dimensional understanding of GIS that creates a dichotomy between those with the discourse around GIS Skepticism and doubt is vital when considering GIS technology and work done using a GIS. It's important to ask questions such as: where is the data coming from? Why was the data collected? Who collected the data?

Furthermore, all GIS software lack features that would make their use and application more inclusive. All data entered into a GIS must be "clean" and formatted in a very specific way. This makes GIS an inherently exclusive software because people need to have the tools and technology to collect data in a certain way in order to put it into a GIS and analyze it(Seiber 2007).

A GIS needs to be able to display more than cartographic and attribute information and beyond raster’s and vectors. It needs to integrate non-geographic data such as storytelling, mental maps, or oral histories.

There are many ways in which GIS can be used inappropriately. Thus, none of my work should be used with the intent to surveil or harm people or the planet.

QGIS:

In the first lab, we created a model to calculate direction and distance from a point.

The purpose of a model is to allow users to reduce the amount of redundant clicking they have to do. By only having to put in the initial parameters, using a model allows user to experiment with different parameters and data in an efficient manner. The model automates the user experience.

Model:

This model takes two inputs. The first input can be a polygon or a point. It is supposed to be the CBD of an urban area. Users can input a polygon and, by using the centroids and mean coordinates functions, the model will find the centroid of the polygon. However, users cannot put in multiple polygons. Thus, if you have a whole metro area, you have to dissolve all of the tracts before putting the parameters through the model.

Field Calculator (distance):

The field calculator takes the centroid of the original polygon and transforms it to EPSG: 4326 so that we can calculate the distance accurately. It then calculates the distance from the CBD to each centroid in each census tract.
```

distance(

transform( centroid($geometry), layer_property(   @inputfeature2   , 'crs'), 'EPSG:4326') ,

transform( make_point ( @Mean_coordinate_s__OUTPUT_maxx  ,  @Mean_coordinate_s__OUTPUT_maxy ), 
layer_property(    @cbdselection     , 'crs'), 'EPSG:4326')
 
 )
```

Field Calculator Direction (degrees):

```
degrees( azimuth(  

transform(make_point(  @Mean_coordinate_s__OUTPUT_maxx , @Mean_coordinate_s__OUTPUT_maxy ), 
layer_property( @citycenter, 'crs'), 'EPSG:54004'),

transform(centroid($geometry), layer_property(  @inputfeatures2 ,  'crs'), 'EPSG:54004')

))
```

Direction is calculated using the azimuth() function. The azimuth() function calculates direction in radians. Thus, the degrees() function is used to convert direction from radians to degrees.

Field Calculator Direction (cardinal direction):
```
CASE
WHEN attribute(concat(@fieldnameprefix, 'Dir')) >= 45 AND  attribute(concat(@fieldnameprefix, 'Dir')) <= 135 THEN 'East' 
WHEN attribute(concat(@fieldnameprefix, 'Dir')) >135 AND attribute(concat(@fieldnameprefix, 'Dir')) <=225 THEN 'South'
WHEN attribute(concat(@fieldnameprefix, 'Dir')) >225 AND attribute(concat(@fieldnameprefix, 'Dir')) <=315 THEN 'West'
ELSE 'North'
END

```
The results from the direction calculator are divided into 4 sections and assigned cardinal directions. 

![Model](new_model.PNG)

Here are two maps that show the results of my model using the entire states of KS from the test data below.

![Cardinal Direction](./Cardinal_direction_map.png)

![Distance Map](./Distance_map.png)

Here are two graphs I made using the entire state of Kansas. I used an arbitrary point in the Northeast corner of the state as the City Center and all the census tracts as the Input Features. 

This [graph](./dir_plot.html) shows how the direction impacts the median rent based on Census Tracts in Kansas.

This [graph](./dist_plot.html) shows how the distance from the point impacts the median rent based on Census Tracts in Kansas. The jump in Median Rent around 50k is the Kansas City Metropolitan area and the jump around 250k is the Wichita Metropolitan area. This shows that land closer to city is more valuable than land farther from city centers. Cities typically have more services and amenities than areas outside cities. People are willing to pay more to live closer to these amenities. 

Here are two maps that show the results of the model using the Wichita metropolitcan area from the test data below. Unlike the analysis above, this offers an understanding of urban geographic theory. 

![Wichitacard](./dirwichita.png)

![Wichitadist](./distwchita.png)

This [graph](./polar_plot_wich.html) shows the relationship between the direction from the Wichita metro area centroid and the median gross rent for each census tract in the metro area. The polar plot shows there is not a significant relationship between direction from the centroid and median gross rent. 

This [graph](./scatter_plot_wich.html) shows the relationship between the distance from the Wichita metro area centroid and the median gross rent for each census tract in the metro area. The graph shows that Median Gross Rent is generally higher the closer you live to the Wichita metro area centroid. While the median gross rent is high in places near the centroid and low in places near the centroid, the median gross rent is significantly lower on average 0.3 km from the centroid.


[Model](./final_model.model3)

[Wichita Test Data](./Data.gpkg)

[Kansas Test Data](./Model_test_data.gpkg)

The Wichita Test Data includes two shp files, the census tracts for the Wichita metro area with Median Gross Rent and the Latinx population joined and the centroid of the Wichita metro area. The Kansas Test Data includes two shp files with the proper data, the census tracts for all of Kansas and an arbitrary point in the Northeast of KS. All other files in the Kansas geopackage do not have useful data. 

[back to Main Page](chriskgernon.github.io/index.md)
