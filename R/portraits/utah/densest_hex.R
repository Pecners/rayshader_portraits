library(sf)
library(tidyverse)
library(elevatr)
library(rayshader)
library(glue)
library(colorspace)
library(tigris)
library(stars)
library(NatParksPalettes)
library(leaflet)
library(htmlwidgets)
library(webshot)

# Set map name that will be used in file names, and
# to get get boundaries from master NPS list

map <- "utah"

# Kontur data source: https://data.humdata.org/organization/kontur
d_layers <- st_layers("data/kontur/kontur_population_US_20220630.gpkg")
d_crs <- d_layers[["crs"]][[1]][[2]]

s <- states() |>
  st_transform(crs = d_crs)

st <- s |>
  filter(NAME == str_to_title(str_replace_all(map, "_", " ")))

wkt_st <- st_as_text(st[[1,"geometry"]])

data <- st_read("data/kontur/kontur_population_US_20220630.gpkg",
                wkt_filter = wkt_st)

# data |>
#   ggplot() +
#   geom_sf()

st_d <- st_join(data, st, left = FALSE)

ll <- st_centroid(st_d |> filter(population == max(population))) |> 
  st_transform(crs = "+proj=longlat +datum=WGS84") |> 
  st_coordinates() 

walk(c(11, 14), function(z) {
  max_ca <- leaflet() |>
    addTiles() |>
    addPolygons(data = st_d |>
                  filter(population == max(population)) |>
                  st_transform(crs = "+proj=longlat +datum=WGS84")) |>
    setView(lat = ll[[2]], lng = ll[[1]], zoom = z)
  
  saveWidget(max_ca, glue("R/portraits/{map}/temp.html"), selfcontained = FALSE)
  webshot(glue("R/portraits/{map}/temp.html"),
          file = glue("images/{map}/max_wi_zoom_{z}.png"),
          cliprect = "viewport")
})


