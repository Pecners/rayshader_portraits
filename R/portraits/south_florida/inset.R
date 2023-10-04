land <- rnaturalearth::ne_download(type = "land", category = "physical", scale = "large")  %>%
  st_as_sf() %>%
  st_transform(., crs = st_crs(fl_counties)) |> 
  st_union()


skinny_s <- st_intersection(fl_counties, land)

these_skinny <- skinny_s |> 
  filter(NAME %in% c("Miami-Dade", "Broward", "Palm Beach"))

dc <- darken(colors[8], .25)

skinny_s |> 
  ggplot() +
  geom_sf(fill = NA, color = dc) +
  geom_sf(data = these_skinny, color = NA, 
          fill = alpha(colors[8], .25),
          linewidth = unit(2, "mm")) +
  theme_void() +
  theme(plot.background = element_rect(color = dc, fill = NA, 
                                       linewidth = 1))

ggsave("images/south_florida/inset.png", width = 10)
