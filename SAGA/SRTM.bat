::set the path to your SAGA program
SET PATH=%PATH%;c:\saga6

::set the prefix to use for all names and outputs
SET pre=SRTM_Dem

::set the directory in which you want to save ouputs. In the example below, part of the directory name is the prefix you entered above
SET od=W:\GEOG323\Lab3\%pre%

:: the following creates the output directory if it doesn't exist already
if not exist %od% mkdir %od%


:: Run Mosaicking tool, with consideration for the input -GRIDS, the -
saga_cmd grid_tools 3 -GRIDS=S03E037.sgrd;S04E037.sgrd; -NAME=%pre%Mosaic -TYPE=9 -RESAMPLING=0 -OVERLAP=1 -MATCH=0 -TARGET_OUT_GRID=%od%\%pre%mosaic.sgrd

:: Run UTM Projection tool
saga_cmd pj_proj4 24 -SOURCE=%od%\%pre%mosaic.sgrd -RESAMPLING=0 -KEEP_TYPE=1 -GRID=%od%\%pre%mosaicUTM.sgrd -UTM_ZONE=37 -UTM_SOUTH=1

:: Run Hillshade Tool
saga_cmd ta_lighting 0 -ELEVATION=%od%\%pre%mosaicUTM.sgrd -SHADE=%od%\%pre%hillshade.sgrd -METHOD=0 -POSITION=0 -AZIMUTH=315.000000 -DECLINATION=45.000000 -DATE=2019-10-03 -TIME=12.000000 -EXAGGERATION=1.000000 -UNIT=0 -SHADOW=0 -NDIRS=8 -RADIUS=10.000000

::Run Sink Drainage route Detection Tool
saga_cmd ta_preprocessor 1 -ELEVATION=%od%\%pre%mosaicUTM.sgrd -SINKROUTE=%od%\%pre%sink_route.sgrd -THRESHOLD=0 -THRSHEIGHT=100.000000

::Run Sink Removal
saga_cmd ta_preprocessor 2 -DEM=%od%\%pre%mosaicUTM.sgrd -SINKROUTE=%od%\%pre%sink_route.sgrd -DEM_PREPROC=%od%\%pre%sink_removed.sgrd -METHOD=1 -THRESHOLD=0 -THRSHEIGHT=100.000000

::Run Flow Accumulation (top-down)
saga_cmd ta_hydrology 0 -ELEVATION=%od%\%pre%sink_removed.sgrd  -SINKROUTE=%od%\%pre%sink_route.sgrd -FLOW=%od%\%pre%flow_accumulation.sgrd -STEP=1 -FLOW_UNIT=0 -METHOD=4 -LINEAR_MIN=500 -CONVERGENCE=1.100000

::Channel Network 
saga_cmd ta_channels 0 -ELEVATION=%od%\%pre%sink_removed.sgrd -SINKROUTE=%od%\%pre%sink_route.sgrd -CHNLNTWRK=%od%\%pre%channel_network.sgrd -SHAPES=%od%\%pre%channel_network.shp -INIT_GRID=%od%\%pre%flow_accumulation.sgrd -INIT_METHOD=2 -INIT_VALUE=10000 -MINLEN=10

::print a completion message so that uneasy users feel confident that the batch script has finished!
ECHO Processing Complete!
PAUSE
