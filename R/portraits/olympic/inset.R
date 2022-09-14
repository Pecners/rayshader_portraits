library(tidyverse)
library(rnaturalearth)
library(magick)
library(ggfx)
library(tigris)
library(ggstar)
library(sf)
library(glue)

sf_use_s2(FALSE)

# inset map -- need to comment this code...
header <- readRDS("R/portraits/olympic/header.rds")

# Not sure why, but need to do this for ortho here
sf_use_s2(FALSE)

world <- ne_countries(scale = "medium", returnclass = "sf")

gl <- ne_download(type = "lakes", category = "physical", scale = "large")  %>%
  st_as_sf() %>%
  st_transform(., crs = st_crs(world))

states <- states(resolution = "5m")

ocean <- ne_download(type = "ocean", category = "physical", scale = "large")  %>%
  st_as_sf() %>%
  st_transform(., crs = st_crs(states))

wa <- states |> 
  filter(NAME == "Washington") |> 
  st_difference(st_union(ocean))

# gl now has a lot of lakes, need to specify our 
# Great Lakes

lakes <- c("Lake Erie",
           "Lake Michigan",
           "Lake Superior",
           "Lake Huron",
           "Lake Ontario")

gl <- gl %>%
  filter(name %in% lakes)

# remove great lakes
w <- st_difference(world, st_union(gl))

# Set USA center coords
coords <- c(-96, 40)

prj <- glue("+proj=ortho +lat_0={coords[2]} +lon_0={coords[1]} +x_0=0 +y_0=0 +a=6375000 +b=6375000 +units=m +no_defs")

# Create circle of water to simulate globe in ortho projection
water <- st_sfc(st_point(coords), crs = prj) %>%
  st_buffer(., 3500000) %>%
  st_transform(crs = 4326)

done_world <- st_intersection(w, water)

text_color <- header$colors[5]

loc_plot <- ggplot(data = done_world) +
  geom_sf(data = water, fill = "grey98", color = NA) +
  geom_sf(aes(fill = ifelse(name == "United States", "grey80", "grey90")), 
          size = .1, color = NA) +
  geom_sf_text(aes(label = ifelse(name == "United States", "USA", "")),
               size = 10, color = "grey50", family = "Cinzel",
               fontface = "bold",
               nudge_x = -1e5, nudge_y = 1e5) +
  geom_sf(data = wa, fill = text_color, color = NA) +
  geom_sf_text(data = wa, aes(label = NAME),
               nudge_x = 4e5, hjust = 0, family = "Cinzel",
               color = text_color, size = 9, fontface = "bold") +
  geom_sf(data = water, fill = NA, color = "grey70", size = 2) +
  scale_fill_identity() +
  coord_sf(crs = prj) +
  theme_void()

loc_plot


ggsave(loc_plot, filename = glue("images/{header$map}/{header$pal}_inset.png"), w = 4*1.5, h = 3*1.5)

img <- image_read(glue("images/{header$map}/{header$pal}_inset.png"))
info <- image_info(img)

# Create shadow, scale to flatten and seem like floor at bottom
s <- image_shadow_mask(img, geometry = "20x100") |>
  image_resize(geometry = glue("{info$width}x{info$height*.1}!"))

# create blank canvas
blank <- image_blank(width = info$width, height = info$height, color = "none")

# Make sure to use 'plus', otherwise transparency is inherited from blank
out <- image_composite(blank, s, gravity = "south", operator = "plus") |>
  image_composite(img, operator = "plus")

out

#image_write(out, glue("images/{header$map}/{header$pal}_inset.png"))


wa_places <- places(state = "WA")

olympia <- wa_places |> 
  filter(NAME == "Olympia") |> 
  mutate(geometry = st_centroid(geometry)) |> 
  st_transform(crs = 32148)

with_coords <- olympia |> 
  as_tibble() |> 
  cbind(st_coordinates(olympia$geometry))

data <- st_read("data/nps_boundary/nps_boundary.shp") |>
  filter(str_detect(PARKNAME, str_to_title(str_replace(header$map, "_", " "))))|> 
  st_transform(crs = 32148)

wa |> 
  ggplot() + 
  with_shadow(geom_sf(fill = "grey98", color = "grey50"), colour = "grey50",
              x_offset = 0, y_offset = 30, sigma = 50) + 
  geom_sf_text(aes(label = str_to_upper(NAME)), color = "grey50", 
               family = "Cinzel", fontface = "bold",
               nudge_y = -100000, nudge_x = 0, size = 10) +
  geom_sf(data = data, color = text_color, fill = text_color) +
  geom_sf_label(data = data, aes(label = UNIT_NAME), family = "Cinzel",
               fontface = "bold", hjust = 0,
               nudge_x = 10000, nudge_y = 50000,
               color = text_color, size = 10, 
               fill = alpha("grey98", .75), label.size = 0,
               label.padding = unit(.1, "cm")) +
  geom_star(data = with_coords, aes(x = X, y = Y),
            fill = "grey50", color = "grey50", size = 4) +
  geom_sf_text(data = olympia, aes(label = NAME), color = "grey50", size = 10,
               family = "Cinzel", fontface = "bold",
               hjust = 0, nudge_x = 5000, nudge_y = -10000) +
  coord_sf(crs = 32148, clip = "off") +
  theme_void()

ggsave(glue("images/{header$map}/sc_inset.png"))

sc_img <- image_read(glue("images/{header$map}/sc_inset.png"))


both <- image_blank(width = image_info(sc_img)$width * 1.5, height = image_info(sc_img)$height, color = "none") |> 
  image_composite(sc_img, operator = "plus", gravity = "east") |> 
  image_composite(image_scale(out, "75%"), operator = "plus", gravity = "west", 
                  offset = "+250+500")

both

image_write(both, glue("images/{header$map}/final_inset.png"))

