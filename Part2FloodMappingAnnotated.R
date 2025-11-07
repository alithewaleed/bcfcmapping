#Set directory if not done already. This will look different depending on where 
#your files for the project are saved
setwd("C:/Users/aliwa/OneDrive/Desktop/BCFC stuff")
getwd()

#Open libraries, install any as needed.

library(leaflet)
library(sf) 
library(dplyr)
library(urbnmapr)
library(ggplot2)
library(readr)
library(urbnmapr)

#2006 map:
flood1 <- st_read("C:/Users/aliwa/OneDrive/Desktop/BCFC stuff/flood_2006/2006_Flood.shp")
flood_xx <- st_transform(flood1, crs = 4326)

leaflet(flood_xx) %>%
  addPolygons(
    color = "sienna",
    weight = 1,
    fillColor = "darkorange",
    fillOpacity = 0.6
  ) %>%
  addProviderTiles(providers$CartoDB.Positron)

#2011 map:
flood2 <- st_read("C:/Users/aliwa/OneDrive/Desktop/BCFC stuff/flood_2011/Flood_2011_09_08_High_Water.shp")
flood_ll <- st_transform(flood2, crs = 4326)

leaflet(flood_ll) %>%
  addPolygons(
    color = "firebrick",
    weight = 1,
    fillColor = "maroon",
    fillOpacity = 0.6
  ) %>%
  addProviderTiles(providers$CartoDB.Positron)



