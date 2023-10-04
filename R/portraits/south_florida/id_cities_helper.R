library(tidycensus)

vars <- load_variables(dataset = "acs1", year = "2021")

fl_places <- get_acs(geography = "place",
                     state = "florida",
                     variables = "B01001A_001", 
                     geometry = TRUE)

fl_places <- st_transform(fl_places, crs = st_crs(these_counties))
these_places <- st_join(fl_places, these_counties, left = FALSE) |> 
  arrange(desc(estimate)) |> 
  head(10)


these_counties |> 
  ggplot() +
  geom_sf() +
  geom_sf(data = these_counties, fill = "red") +
  geom_sf(data = st_d, fill = "white", color = NA) +
  geom_sf(data = these_places[c(4, 8, 9),], fill = "blue", color = NA) +
  geom_sf_text(data = these_places,
               aes(label = NAME)) +
  coord_sf(clip = "off") +
  theme_void()


make_place <- function(place) {
  st_d <- st_join(data, place, left = FALSE)
}

this_one <- make_place(these_places[c(4, 6, 8, 9),])
changed <- st_d |> 
  mutate(population = ifelse(h3 %in% this_one$h3, population, 1))


bb <- st_bbox(changed)
yind <- st_distance(st_point(c(bb[["xmin"]], bb[["ymin"]])), 
                    st_point(c(bb[["xmin"]], bb[["ymax"]])))
xind <- st_distance(st_point(c(bb[["xmin"]], bb[["ymin"]])), 
                    st_point(c(bb[["xmax"]], bb[["ymin"]])))

if (yind > xind) {
  y_rat <- 1
  x_rat <- xind / yind
} else {
  x_rat <- 1
  y_rat <- yind / xind
}

size <- 1000
rast <- st_rasterize(changed |> 
                       select(population, geom),
                     nx = floor(size * x_rat), ny = floor(size * y_rat))


mat <- matrix(rast$population, nrow = floor(size * x_rat), ncol = floor(size * y_rat))

# set up color palette

pal <- "miami"

c1 <- mixcolor(alpha = seq(from = 0, to = 1, by = .25), color1 =  hex2RGB("#00efff"), 
               color2 = hex2RGB("#ffffff")) |> 
  hex()
c2 <- mixcolor(alpha = seq(from = 0, to = 1, by = .25), color1 =  hex2RGB("#ff4992"), 
               color2 = hex2RGB("#ffffff")) |> 
  hex()

colors <- c(c1[1:4], rev(c2[1:4]))
swatchplot(colors)

texture <- grDevices::colorRampPalette(colors, 4)(256)

swatchplot(texture)
###################
# Build 3D Object #
###################

# Keep this line so as you're iterating you don't forget to close the
# previous window

try(rgl::close3d())

# Create the initial 3D object
mat |> 
  height_shade(texture = texture) |> 
  plot_3d(heightmap = mat, 
          # This is my preference, I don't love the `solid` in most cases
          solid = FALSE,
          soliddepth = 0,
          # You might need to hone this in depending on the data resolution;
          # lower values exaggerate the height
          z = 50 / (size / 1000),
          # Set the location of the shadow, i.e. where the floor is.
          # This is on the same scale as your data, so call `zelev` to see the
          # min/max, and set it however far below min as you like.
          shadowdepth = 0,
          # Set the window size relatively small with the dimensions of our data.
          # Don't make this too big because it will just take longer to build,
          # and we're going to resize with `render_highquality()` below.
          windowsize = c(800,800), 
          # This is the azimuth, like the angle of the sun.
          # 90 degrees is directly above, 0 degrees is a profile view.
          phi = 90, 
          zoom = 1, 
          # `theta` is the rotations of the map. Keeping it at 0 will preserve
          # the standard (i.e. north is up) orientation of a plot
          theta = 0, 
          background = "white") 

# Use this to adjust the view after building the window object
render_camera(phi = 35, zoom = .75, theta = 30)
