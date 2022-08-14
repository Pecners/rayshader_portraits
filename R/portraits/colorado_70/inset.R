library(ggmap)

header <- readRDS("R/portraits/bryce_canyon/header.rds")


s <- spData::us_states %>% 
  filter(NAME == "Colorado")
r <- tigris::primary_roads()

bbox <- st_bbox(data)
bbox["xmax"] <- -105.75
bbox["xmin"] <- -106.5
bbox["ymax"] <- 39.8
bbox["ymin"] <- 39.4

bbox_sf <- st_as_sfc(bbox)


  
co_r <- st_intersection(r, s)

colors <- header$colors



p <- co_r %>% 
  ggplot() +
  geom_sf(data = bbox_sf, fill = alpha(colors[3], .25),
          color = colors[3]) +
  geom_sf(data = s, fill = NA, color = colors[1]) +
  geom_sf(color = colors[1], size = 1) +
  geom_sf(color = colors[3], size = .4) +
  theme_void() +
  theme(text = element_text(family = "Denk One", color = colors[1],
                            size = 40),
        plot.title = element_text(hjust = .25, 
                                  margin = margin(t = 30, b = -100))) +
  coord_sf(crs = 2231) +
  labs(title = "Colorado")
p

ggsave("images/colorado_70/inset.png", plot = p, bg = "transparent")

