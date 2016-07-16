# SF-Guide
Guide for new San Francisco residents

When the app launches, it displays different districts in San Francisco with color coding . The district with most reported crime incidents has ff0000(red) and so on and least three districts has a6ff00(green) as described in requirement

App initially displays 50 latest incidents after launch and when ever user scrolls or zooms to a new region . ‘Load More Incidents’ button is provided at bottom to view next 50 incidents in the same region.

Web service URL’s used

https://data.sfgov.org/resource/cuks-n6tp.json?$select=pddistrict,COUNT(incidntnum),convex_hull(location)&$group=pddistrict&$order=COUNT(incidntnum)desc

This URL will fetch data which contains all district names with count of incidents reported in the district and coordinates that circumference the district. The coordinates are used to draw overlay views on the map

https://data.sfgov.org/resource/cuks-n6tp.json?$select=x,y,date,category,incidntnum,address&$where=within_box(location,%lf,%lf,%lf,%lf)%%20AND%%20date%%20%%3E%%20'%@'&$order=date%%20desc&$limit=50&$offset=0

This URL will fetch incidents data for a coordinates range. This is used to fetch incidents based on the region displayed on map view. There is date condition to fetch only incidents within last month and there is also paging with limit 50.


Observations

The district boundaries are not properly laid out and are overlapping with each other. This is because of the data provided by the web service. 
For example, for few incidents which are tagged as ‘BAYVIEW’ has geographical coordinates in ‘SOUTHERN’ geographical region and vice versa. Convex_hull function used in the web service returns circumference coordinates based on the district name as data is grouped on district name and since multiple districts has overlapping coordinates region are overlapping.

There is no validation to show a popup or disable button when user clicks on ‘Load More incidents’ and there are no more incidents to show.





