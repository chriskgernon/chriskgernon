This is where I put my blog posts.

Blog Post 1 (9/16/2019)

The new age of big data has created a lot possibilities for analysis of humans and the choices they make. This article follows that trend. It uses Twitter and mobile positioning data to analyze patterns, trends and associations of human behaviour and interactions. The authors use Friuu-Venezia Giulia, a region in northeastern Italy, as a case study. Their results show the percentage difference of Italians and percentage difference of foreigners; density of tweets; and origin destination flows for Italians and origin destination flows for foreigners for specific days– days with events and “normal” days without events– in 2016. Their findings show that there is a greater concentration of foreigners and tweets in areas that have events on those days, and there is a much higher flux of people on the event day of people moving from regions surrounding the event to the event region. Also, their findings show there is a higher presence of people on sunny days than rainy days, and more foreigners are found in regions with more tourist attractions like historic centers and ornate architecture. However, I find a lot of their results hard to understand. For example, the authors use color to show two variables: tweet density and tweet relevance. However, it is hard to analyze two variables when color is the only factor used to visualize the variables. Regardless, the results of the case study are intuitive: there are more people in areas with nice weather and there are people moving from non-event areas to areas with events. 

The fact that QGIS is a free, open-source technology had a big impact on the study. The authors used QGIS to analyze their data as well as visualize their results. If QGIS was not open source, the authors would be forced to either pay a company a large sum of money for a GIS license or drastically lower the scale of their analysis. Instead of focusing on a whole region in Italy, they may have only been able to analyze a small city or part of a city. Additionally, if the authors were unable to afford the cost of a GIS license, they would be hard pressed to show decent visualizations of their findings. 

[Article Link](https://www.int-arch-photogramm-remote-sens-spatial-inf-sci.net/XLII-4-W8/199/2018/isprs-archives-XLII-4-W8-199-2018.pdf)


Blog Post 2 (11/17/2019)

I am researching potential article to replicate for my lab this week. I found this study and conculeded the following: 

Link to article :https://www.tandfonline.com/doi/pdf/10.1080/10548408.2017.1401508


Purpose: This study was a deductive study, and the purpose of it was to offer a framework for social media analytics and show that it can be used as a tool to 
understand a customers experience at a destination. 

Source:  Twitter Archiving Google Sheet (TAGS) Version 6.0 was used to collect the tweets.
No specific words were used in the quer parameters. The center of the Disneyland (latitude: 33.812560, longitude: −117.918985)
was chosen as the center, and all tweets within a 0.23 mile radius were collected. Tweets were collected from November
16 2014 to August 22 2015. 120,241 tweets were gathered. 

The study is not reprodubible becuase you cannot get the same data that the study collected; however,
the study is replicable. You could apply the same methods and produce similar results with new tweets. Or, you could 
apply the study's methods to a completely different location with tourists/consumers and get similar results.

Libraries required to replicate study: stringi, tidyverse, stringr, plyr, sentistrength(?)



