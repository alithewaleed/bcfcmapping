#Set directory if not done already. This will look different depending on where 
#your files for the project are saved
setwd("C:/Users/aliwa/OneDrive/Desktop/BCFC stuff")
getwd()

#Install any packages not already installed:

install.packages("devtools")
devtools::install_github("UrbanInstitute/urbnmapr")

#Run the libraries. Install packages as needed if not installed.

library(leaflet)
library(sf) 
library(dplyr)
library(urbnmapr)
library(ggplot2)
library(readr)


#Load in the efam_data_geocoded2024.csv file, this has longitude and latitude values for food
#pantries and other food sources throughout the county. This will also look
#different depending on where you put the csv file.
efam <- read_csv("C:/Users/aliwa/OneDrive/Desktop/BCFC stuff/efam_data_geocoded2024.csv")

#Then run the remaining code to generate the map

efam <- efam %>%
  mutate(
    Latitude  = as.numeric(Latitude),
    Longitude = as.numeric(Longitude)
  ) %>%
  filter(!is.na(Latitude), !is.na(Longitude))

efam_sf <- st_as_sf(efam, coords = c("Longitude", "Latitude"), crs = 4326, remove = FALSE)

type_vals <- sort(unique(efam_sf$Type))
pal <- colorFactor("Set2", type_vals)

leaflet(efam_sf, options = leafletOptions(minZoom = 3)) %>%
  addProviderTiles(providers$CartoDB.Positron) %>%
  addCircleMarkers(
    radius = 6,
    stroke = TRUE, weight = 1, opacity = 1,
    fillOpacity = 0.8,
    color = "#333333",
    fillColor = ~pal(Type),
    label = ~Name,
    clusterOptions = markerClusterOptions()
  ) %>%
  addLegend("topright", pal = pal, values = ~Type, title = "EFAM Type", opacity = 1)

counties_sf <- get_urbn_map("counties", sf = TRUE)

efam_counts <- efam %>%
  mutate(
    County_clean = trimws(gsub("[[:space:]]+[Cc]ounty$", "", County)),  
    State        = toupper(State)
  ) %>%
  left_join(
    counties_sf %>%
      st_drop_geometry() %>%
      distinct(state_abbv, county_name, county_fips) %>%
      mutate(county_name_clean = trimws(gsub("[[:space:]]+[Cc]ounty$", "", county_name))),
    by = c("State" = "state_abbv", "County_clean" = "county_name_clean")
  ) %>%
  count(county_fips, name = "n_sites")

choropleth_sf <- counties_sf %>%
  left_join(efam_counts, by = "county_fips")

ggplot(choropleth_sf) +
  geom_sf(aes(fill = n_sites), color = NA) +
  scale_fill_gradient(low = "#fee8c8", high = "#e34a33", na.value = "grey90", name = "EFAM sites") +
  coord_sf(datum = NA) +
  labs(title = "EFAM Locations per County") +
  theme_minimal(base_size = 12) +
  theme(
    panel.grid.major = element_blank(),
    axis.text = elnement_blank(),
    axis.title = element_blank()
  )
