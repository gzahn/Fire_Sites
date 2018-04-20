# Fire_Sites

#### Methods of selection for Utah historic forest fire sites
This starts with raw data from 300 hand-picked (ARCGIS) sites that were run through GeoDataCrawler to extract national landsat and other data.
This code is broken into two parts. The first is Import_and_Clean.R and the second is Find_Similarites.R

Meaningful quantitative soil and environmental factors were selected and run through NMDS to find a subset of samples that were 
reasonably close to each other in Euclidean distance (when based on all those variables) that still had a wide range of "Times since burn."
