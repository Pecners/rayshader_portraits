# inset map -- need to comment this code...
header <- readRDS("R/portraits/CONFIG_MAP/header.rds")

world <- rnaturalearth::ne_countries(scale = "small", returnclass = "sf")

coords <- header$coords

prj <- glue("+proj=ortho +lat_0={coords[2]} +lon_0={coords[1]} +x_0=0 +y_0=0 +a=6375000 +b=6375000 +units=m +no_defs")

water <- st_sfc(st_point(c(0, 0)), crs = prj) %>%
  st_buffer(., 6371000) %>%
  st_transform(crs = 4326)

circle_coords <- st_coordinates(water)[, c(1,2)]
circle_coords <- circle_coords[order(circle_coords[, 1]),]
circle_coords <- circle_coords[!duplicated(circle_coords),]

rectangle <- list(rbind(circle_coords,
                        c(X = 180, circle_coords[nrow(circle_coords), 'Y']),
                        c(X = 180, Y = 90),
                        c(X = -180, Y = 90),
                        c(X = -180, circle_coords[1, 'Y']),
                        circle_coords[1, c('X','Y')])) %>% 
  st_polygon() %>% st_sfc(crs = 4326)


rectangle %>%
  ggplot()+
  geom_sf(data = world) +
  geom_sf(color = "red", fill = alpha("red", .5)) 

sf::sf_use_s2(FALSE)
w <- st_intersection(world, rectangle)
w %>%
  ggplot() +
  geom_sf()

spot <- tibble(x = coords[1], y = coords[2]) |> 
  st_as_sf(coords = c("x", "y"), crs = 4326)

colors <- header$colors
water_color <- colors[7]
text_color <- colors[1]

loc_plot <- ggplot(data = w) +
  geom_sf(data = water, color = NA, fill = alpha("white", .75)) +
  geom_sf(fill = "red", size = .1, color = "white") +
  coord_sf(crs = prj) +
  theme_void() 

loc_plot
ggsave(loc_plot, filename = glue("images/{header$map}/{header$pal}_inset.png"), w = 4*1.5, h = 3*1.5)
