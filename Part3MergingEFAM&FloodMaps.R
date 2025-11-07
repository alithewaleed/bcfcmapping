# If you were able to run the previous two parts to completion then this one should work too.
# They should all be run in the same session one after the other since Part 2 creates variables
# that are used in this part.
library(leaflet)
efam_sf  <- st_transform(efam_sf, 4326)
flood_ll <- st_transform(flood_ll, 4326)  
flood_xx <- st_transform(flood_xx, 4326)
leaflet() %>%
  addProviderTiles(providers$CartoDB.Positron) %>%
  
  addPolygons(
    data = flood_ll,
    color = "firebrick",
    fillColor = "maroon",
    fillOpacity = 0.5,
    weight = 1,
    group = "2011 Flood"
  ) %>%
  addPolygons(
    data = flood_xx,
    color = "sienna",
    fillColor = "darkorange",
    fillOpacity = 0.5,
    weight = 1,
    group = "2006 Flood"
  ) %>%
  
  addCircleMarkers(
    data = efam_sf,
    radius = 5,
    stroke = TRUE, weight = 1,
    color = "#333333",
    fillColor = ~pal(Type),
    fillOpacity = 0.9,
    label = ~Name,
    group = "EFAM Sites"
  ) %>%
  
  addLayersControl(
    overlayGroups = c("EFAM Sites", "2006 Flood", "2011 Flood"),
    options = layersControlOptions(collapsed = FALSE)
  ) %>%
  addLegend("bottomright", pal = pal, values = efam_sf$Type,
            title = "EFAM Type", opacity = 1)
