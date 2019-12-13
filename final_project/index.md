# Purpose
The purpose of my final project was to learn something new. I am interested in data visualization and had minimal experience with interactive web mapping, so I decided to learn how to use [mapbox](https://www.mapbox.com/). My map currently visualizes opiod distribution data in Shawnee County. I chose Shawnee County because that is where I am from. 

# Sources and Help
  *  https://docs.mapbox.com/mapbox-gl-js/example/cluster-html/
  * https://docs.mapbox.com/mapbox-gl-js/example/cluster/
  * https://docs.mapbox.com/help/tutorials/add-points-pt-3/
  * https://docs.mapbox.com/help/tutorials/add-points-pt-2/
  * https://docs.mapbox.com/help/tutorials/add-points-pt-1/
  * QGIS to convert shp file to GEOJSON
  * http://www.convertcsv.com/csv-to-geojson.htm
  
# Method

First, I downloaded the opiod data from a Washington Post Database found on this [website](https://www.washingtonpost.com/graphics/2019/investigations/dea-pain-pill-database/). 

![pic](./download.PNG/)

Second, I needed to geocode the addresses from the data because there were no longitude latitude coordinates. I used the plug-in on Google Sheets titled ```Geocode by Awesome Table```. Unfortunatley, there was a limit on the number of points I could geocode in one day, so I was only able to geocode 9,720 of the 126,504 entried for the count. Additionally, because it is such a large dataset, I was not even able to load all of the data into a Google Sheet or else the website would crash.

Third, I used a (CSV to GEOGJON converter website)[http://www.convertcsv.com/csv-to-geojson.htm] to convert the latitude, longitude coordinates into a GEOJSON, so I could visualize the data in Mapbox.

Fourth, uploading my data took several steps. I made a [Mapbox](https://www.mapbox.com/) account, and I used Mapbox studio to upload my data and style my basemap and symbols. In order to do this I first uploaded my data as a tileset in Mapbox Studio by clicking on tilesets and uploading the file from my computer.

![pic](./tileset.PNG/)
Next, I converted my dataset into a tileset. Then, I selected the monochrome style. Finally, I uploaded my data into the style.    
