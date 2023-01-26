library(tidyverse)
library(tigris)
library(sf)
library(rnaturalearth)

header <- readRDS("R/portraits/i95/header.rds")

s <- states()

# filter for only contiguous states
skip <- c(
  "Puerto Rico",
  "Alaska",
  "Hawaii",
  "United States Virgin Islands",
  "Commonwealth of the Northern Mariana Islands",
  "American Samoa",
  "Guam"
)

skinny_s <- s |> 
  filter(!NAME %in% skip)


l <- ne_download(type = "lakes", category = "physical", scale = "large") |> 
  st_as_sf(crs = st_crs(states))

lakes <- c("Lake Erie",
           "Lake Michigan",
           "Lake Superior",
           "Lake Huron",
           "Lake Ontario")
gl <- l |>
  filter(name %in% lakes) |>
  st_transform(crs = st_crs(skinny_s)) |> 
  st_union()

land <- ne_download(type = "land", category = "physical", scale = "large")  |>
  st_as_sf() |>
  st_transform(., crs = st_crs(skinny_s)) |> 
  st_union()


skinny_s <- st_difference(skinny_s, gl)

skinny_s <- st_intersection(skinny_s, land)

loc_plot <- skinny_s |> 
  ggplot() +
  geom_sf(fill = NA, color = header$colors[3],
          linewidth = .5) +
  geom_sf(data = header$inset_geo,
          fill = header$colors[7],
          color = header$colors[6],
          linewidth = .5) +
  coord_sf(crs = 2163, ylim = c(NA, 700000)) +
  theme_void() +
  scale_fill_identity()


ggsave(loc_plot, filename = glue("images/{header$map}/{header$pal}_inset.png"))
