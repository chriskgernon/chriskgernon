 Using ASTER data Model 4003 from the US and Japan, I created a Hydrological Flow Model for the area around Mount Kilimanjaro, Tanzania. The analysis was done on SAGA open source GIS
 
 The following is a workflow of the process:

1. Gather and collect digital elevation model data at this [link]( https://search.earthdata.nasa.gov/)

2. Mosaic the grids together

3. Project the grid to the correct UTM zone

After steps two and three, your DEM should look like this:
![DEM](https://github.com/chriskgernon/chriskgernon.github.io/blob/master/DEM.PNG)

4. Create a hillshade to get a visual understanding of the topography you are looking at. I used the default settings for the azimuth : 315 and height : 45.

![Hillshade](https://github.com/chriskgernon/chriskgernon.github.io/blob/master/Analytical_hillshading2.PNG)

5. Use the Sink Drainage Route Detection tool to detect sinks and determine flow through the sinks. This step is necessary so that the hydrological analysis does not get stuck in either real holes or holes created by data errors. The blue represents no sinks, and the colored dots show different values of sinks.

![Sink Drainage](https://github.com/chriskgernon/chriskgernon.github.io/blob/master/Sink_Drainage_route.PNG)

6. Use the Sink Removal tool to remove sinks from the DEM by filling them.

7. Use the Flow Accumulation (Top-Down) tool to calculate where the flow will accumulate. The darker the values, the more accumulation.

![Flow Accumulation](https://github.com/chriskgernon/chriskgernon.github.io/blob/master/Flow_Accumulation.PNG)

8. Use the Channel Network tool to show where the streams are.

![Channel_Network](https://github.com/chriskgernon/chriskgernon.github.io/blob/master/Channel_network.PNG)

[Automating Hydrological Modeling](automating_hydrological_modeling.md)
