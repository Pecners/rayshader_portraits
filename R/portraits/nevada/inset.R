library(rnaturalearth)

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

mix <- mixcolor(alpha = .5, color1 =  hex2RGB(header$colors[2]), 
         color2 = hex2RGB("#DaCab8")) |> 
  hex()

loc_plot <- skinny_s |> 
  ggplot() +
  geom_sf(fill = NA, color = mix,
          linewidth = .3) +
  geom_sf(data = skinny_s |> 
            filter(NAME == "Nevada"),
          fill = alpha(header$colors[6], .5),
          color = header$colors[6],
          linewidth = .5) +
  coord_sf(crs = 2163, ylim = c(NA, 700000)) +
  theme_void() +
  scale_fill_identity()

ggsave(loc_plot, filename = glue("images/{header$map}/{header$pal}_inset.png"))
