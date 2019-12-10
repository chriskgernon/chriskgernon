Lab 10

Twitter is

![counties](countieseastgGetisOrdMapFrame.png)

![counties2](countieseastgGetisOrdMapFrame2.png)

![heat_map](Heat_map.png)

# Method
## Collecting the Data
First, I installed and downloaded all the necessary packages to perform the analysis. 
```R
#install packages for twitter, census, data management, and mapping
install.packages(c("rtweet","tidycensus","tidytext","maps","RPostgres","igraph","tm", "ggplot2","RColorBrewer","rccmisc","ggraph"))


#initialize the libraries. this must be done each time you load the project
library(rtweet)
library(igraph)
library(dplyr)
library(tidytext)
library(tm)
library(tidyr)
library(ggraph)
library(tidycensus)
library(ggplot2)
library(RPostgres)
library(RColorBrewer)
library(DBI)
library(rccmisc)
```

Second, I set up all of the necessary Twitter API information so that I could scrape the data from Twitter. 

```R
twitter_token <- create_token(
  app = "Geog323",  				
  consumer_key = "**********************************",  		
  consumer_secret = "**********************************",
  access_token = "**********************************",
  access_secret = "**********************************"
)
```

Third, I used the ```search_tweets()``` function to collect my dataset of 10000 tweets. I collected tweets from everywhere within 113 miles from Washington D.C. that had either "trump" or "impeachment" or "trial" or "hearing." Twitter only allows apps to collect 18,000 tweets every 15 minutes. So if you are interested in collecting more than 18,000 tweets, users should set```retryonratelimit``` argument to TRUE.

```R
impeachTweets <- search_tweets("trump OR impeachment OR impeach OR trial OR hearing", n=10000, retryonratelimit=FALSE, include_rts=FALSE, token=twitter_token, geocode="38.905008,-77.036571, 113mi")
```

## Temporal Analysis

I created a graph that shows the number of impeachment tweets over time.

![temporal](.\over_time.png)


The following code was what I used to create the graph. ```ts_data``` and ```ts_plot``` are two functions that are part of the ```rtweet``` library. ```ts_data``` returns data containing the frequency of tweets over a specified interval of time.. ```ts_plot``` creates a ggplot2 plot of the frequency of tweets over a specified interval of time.

```R

impeachTweetsHours <- ts_data(impeachTweets, by="hours")
ts_plot(impeachTweets, by="hours", color= "#565656")+
  labs(title = "Tweets about Impeachment on November 14, 2019 Over Time",
       x = "Time", y = "Count")+
  geom_point()+
  theme_light()
  ``` 
  
  
  

 
  ## FIND ONLY PRECISE GEOGRAPHIES
  
  About 0.85% tweets are geo-tagged, which means that the latitude and longitude of a tweet is recorded. (Sloan and Morgan 2015). This location data is incredibly valuable for social scientist. It enables them to establish the geographic context in which the tweeter is located when the tweet. Of the 10000 tweets I collected, 319 contained a place type.
  
reference for lat_lng function: https://rtweet.info/reference/lat_lng.html
adds a lat and long field to the data frame, picked out of the fields you indicate in the c() list
sample function: lat_lng(x, coords = c("coords_coords", "bbox_coords"))

This chunk of code counts the number of unique place types in the dataset.

| Place Type| Count|
| ------------- | ------------- |
| admin|26|
| city|271|
|neighborhood|1|
|poi|21|
|NA|9681|
```
# list and count unique place types
# NA results included based on profile locations, not geotagging / geocoding. If you have these, it indicates that you exhausted the more precise tweets in your search parameters
count(winterTweets, place_type)
```


[twitter data](./status_id.csv)

Citations:
Sloan L, Morgan J (2015) Who Tweets with Their Location? Understanding the Relationship between Demographic Characteristics and the Use of Geoservices and Geotagging on Twitter. PLoS ONE 10(11): e0142209. https://doi.org/10.1371/journal.pone.0142209
