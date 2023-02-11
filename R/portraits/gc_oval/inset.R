library(tigris)
library(rnaturalearth)
library(ggfx)
library(sf)
library(tidyverse)
library(colorspace)
library(glue)

# Load `header` list with needed data
header <- readRDS("R/portraits/gc_oval/header.rds")
colors <- header$colors
swatchplot(colors)

text_color <- colors[6]

park <- st_read("data/nps_boundary/nps_boundary.shp") |>
  filter(str_detect(PARKNAME, "Grand Canyon"))

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

skinny_s |> 
  ggplot() +
  geom_sf()

l <- ne_download(type = "lakes", category = "physical", scale = "large")  %>%
  st_as_sf(., crs = st_crs(states))

lakes <- c("Lake Erie",
           "Lake Michigan",
           "Lake Superior",
           "Lake Huron",
           "Lake Ontario")
gl <- l %>%
  filter(name %in% lakes) %>%
  st_transform(crs = st_crs(skinny_s)) |> 
  st_union()

land <- ne_download(type = "land", category = "physical", scale = "large")  %>%
  st_as_sf() %>%
  st_transform(., crs = st_crs(skinny_s)) |> 
  st_union()


skinny_s <- st_difference(skinny_s, gl)

skinny_s <- st_intersection(skinny_s, land)

south_vc <- c(36.05921417026507, -112.10930676553595) |> 
  rev() |> 
  st_point() |> 
  st_sfc(crs = 4326)

loc_plot <- park |>
  ggplot() +
  geom_sf() +
  geom_sf(data = header$inset,
          color = "red", fill = NA) +
  geom_sf(data = south_vc, color = "blue") +
  theme_void()

ggsave(loc_plot, 
       filename = glue("images/{header$map}/{header$pal}_inset.png"),
       bg = "transparent", width = 20, height = 15)



loc_plot <- skinny_s |> 
  filter(NAME == "Arizona") |> 
  ggplot() +
  geom_sf(fill = NA, color = header$colors[4],
          linewidth = .5) +
  geom_sf(data = park, 
          fill = alpha(colors[4], .1),
          color = colors[4]) +
  geom_sf(data = header$inset,
          fill = alpha(header$colors[6], .5),
          color = header$colors[6],
          linewidth = .5) +
  geom_sf_text(data = header$inset,
               label = "area shown\nat right",
               family = "Cinzel Decorative",
               fontface = "bold",
               size = 15,
               nudge_y = -150000,
               nudge_x = 550000,
               color = colors[6]) +
  annotate(geom = "curve", yend = 1800000, xend = 643062.9,
           y = 1675000, x = 900000, 
           curvature = -.5,
           angle = 50,
           linewidth = 1,
           color = colors[6], arrow = arrow(type = "closed")) +
  geom_sf_text(data = park,
               label = "grand canyon\nnational park",
               family = "Cinzel Decorative",
               fontface = "bold",
               size = 10,
               nudge_y = -300000,
               nudge_x = -350000,
               color = alpha(colors[4], .5)) +
  # geom_sf_text(data = skinny_s |> filter(NAME == "Arizona"),
  #              label = "ARIZONA",
  #              family = "Cinzel Decorative Black",
  #              size = 20,
  #              nudge_y = -500000,
  #              nudge_x = 0,
  #              color = alpha(colors[4], .5)) +
  coord_sf(crs = 2223, clip = "off") +
  theme_void() +
  scale_fill_identity()

ggsave(loc_plot, 
       filename = glue("images/{header$map}/{header$pal}_inset.png"),
       bg = "transparent", width = 20, height = 15)
