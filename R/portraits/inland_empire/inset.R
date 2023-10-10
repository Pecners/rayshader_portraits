land <- rnaturalearth::ne_download(type = "land", category = "physical", scale = "large")  %>%
  st_as_sf() %>%
  st_transform(., crs = st_crs(st_counties)) |> 
  st_union()


skinny_s <- st_intersection(st_counties, land)

these_skinny <- skinny_s |> 
  filter(NAME %in% c("Riverside", "San Bernardino")) 
  
dc <- darken(colors[8], .25)

p <- skinny_s |> 
  ggplot() +
  geom_sf(data = these_skinny, color = NA, 
          fill = alpha(colors[9], .5)) +
  geom_sf(fill = NA, color = colors[9], 
          linewidth = unit(1, "mm")) +
  theme_void() 

ggsave("images/inland_empire/inset.png", plot = p, width = 10)
