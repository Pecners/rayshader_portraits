library(sf)
library(tidyverse)
library(elevatr)
library(rayshader)
library(glue)
library(colorspace)
library(tigris)
library(stars)
library(NatParksPalettes)

# Set map name that will be used in file names, and 
# to get get boundaries from master NPS list

map <- "phi_sf"

# Kontur data source: https://data.humdata.org/organization/kontur
d_layers <- st_layers("data/kontur/kontur_population_US_20220630.gpkg")
d_crs <- d_layers[["crs"]][[1]][[2]]

s <- places(state = c("Pennsylvania", "California")) |> 
  st_transform(crs = d_crs)

p <- c(
  "Philadelphia",
  "San Francisco"
)

st <- s |> 
  filter(NAME %in% p)

st[2,] |> 
  ggplot() +
  geom_sf()

st_1 <- st |> 
  filter(NAME == p[1]) |> 
  select(name = NAME,
         geometry) 

st_2 <- st |> 
  filter(NAME == p[2]) |> 
  select(name = NAME,
         geometry) 

st2_bb <- st_bbox(st_2)
st2_bb[["xmin"]] <- st2_bb$xmin + ((st2_bb$xmax - st2_bb$xmin) * .5)
st2_bb[["ymax"]] <- st2_bb$ymax - ((st2_bb$ymax - st2_bb$ymin) * .1)
st2_bb <- st_as_sfc(st2_bb)

st2_bb |> 
  ggplot() +
  geom_sf() +
  geom_sf(data = st_2, fill = NA, color = "red")

st[2,] <- st_intersection(st[2,], st2_bb)

wkt_1 <- st_as_text(st_1[[1, "geometry"]])
wkt_2 <- st_as_text(st_2d[[1, "geometry"]])

st_dd <- map_df(p, function(i) {
  st_ <- st |> 
    filter(NAME == i) |> 
    select(name = NAME,
           geometry)
  
  wkt_st <- st_as_text(st_[[1, "geometry"]])
  data <- st_read("data/kontur/kontur_population_US_20220630.gpkg",
                  wkt_filter = wkt_st)
  st_join(data, st, left = FALSE) |> 
    mutate(city = i)
})

st_limits <- st_join(st_dd, st, left = FALSE)

st_limits |> 
  ggplot() +
  geom_sf()

# Calculate distance between rivers to help with moving the Thames

shift <- function(d, movement_x = .9, movement_y = 1) {
  
  cities <- unique(d$city)
  
  cent <- map_df(cities, function(i) {
    tmp <- d |> 
      filter(city == i) |> 
      st_union() |> 
      st_centroid() |>
      st_coordinates() |> 
      as_tibble()
  })
  
  diff_x <- cent[[1, "X"]] - cent[[2, "X"]]
  diff_y <- cent[[1, "Y"]] - cent[[2, "Y"]]
  
  to_shift <- d |> 
    filter(city == cities[1])
  
  shifted <- to_shift |> 
    st_coordinates() |> 
    as_tibble() |> 
    mutate(X = X  - diff_x * movement_x,
           Y = Y - diff_y * movement_y) |> 
    st_as_sf(coords = c("X", "Y")) |> 
    group_by(L2) |> 
    summarise(do_union = FALSE) |> 
    st_cast(to = "POLYGON") |> 
    rename(geom = geometry)
  
  f <- bind_cols(shifted, population = to_shift$population) |> 
    bind_rows(d |> 
                filter(city == cities[2]))
  
  return(f)
}

st_d <- shift(st_dd, movement = .995, movement_y = .9)

st_d |> 
  ggplot() +
  geom_sf()


#st_d <- st_intersection(data, st)

bb <- st_bbox(st_d)
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

size <- 8000
rast <- st_rasterize(st_d |> 
                       select(population, geom),
                     nx = floor(size * x_rat), ny = floor(size * y_rat))


mat <- matrix(rast$population, nrow = floor(size * x_rat), ncol = floor(size * y_rat))

# set up color palette

pal <- "olympic"


c1 <- natparks.pals("Olympic", n = 10)
colors <- c1[c(5:1, 10:6)]
swatchplot(colors)

texture <- grDevices::colorRampPalette(colors[10:6])(256)

swatchplot(texture)



###################
# Build 3D Object #
###################

# Keep this line so as you're iterating you don't forget to close the
# previous window

try(rgl::rgl.close())

# Create the initial 3D object
mat |> 
  height_shade(texture = texture) |> 
  plot_3d(heightmap = mat, 
          # This is my preference, I don't love the `solid` in most cases
          solid = TRUE,
          solidcolor = colors[10],
          solidlinecolor = colors[10],
          soliddepth = 0,
          # You might need to hone this in depending on the data resolution;
          # lower values exaggerate the height
          z = 15,
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
render_camera(phi = 45, zoom = .7, theta = 0)

###############################
# Create High Quality Graphic #
###############################

# You should only move on if you have the object set up
# as you want it, including colors, resolution, viewing position, etc.

# Ensure dir exists for these graphics
if (!dir.exists(glue("images/{map}"))) {
  dir.create(glue("images/{map}"))
}

# Set up outfile where graphic will be saved.
# Note that I am not tracking the `images` directory, and this
# is because these files are big enough to make tracking them on
# GitHub difficult. 
outfile <- str_to_lower(glue("images/{map}/{map}_{pal}.png"))

# Now that everything is assigned, save these objects so we
# can use then in our markup script
saveRDS(list(
  map = map,
  pal = pal,
  colors = colors,
  outfile = outfile,
  coords = coords
), glue("R/portraits/{map}/header.rds"))



{
  # Test write a PNG to ensure the file path is good.
  # You don't want `render_highquality()` to fail after it's 
  # taken hours to render.
  if (!file.exists(outfile)) {
    png::writePNG(matrix(1), outfile)
  }
  # I like to track when I start the render
  start_time <- Sys.time()
  cat(glue("Start Time: {start_time}"), "\n")
  render_highquality(
    # We test-wrote to this file above, so we know it's good
    outfile, 
    # See rayrender::render_scene for more info, but best
    # sample method ('sobol') works best with values over 256
    samples = 450, 
    preview = FALSE,
    light = TRUE,
    lightdirection = rev(c(140, 140, 150, 150)),
    lightcolor = c(colors[3], "white", colors[9], "white"),
    lightintensity = c(750, 50, 750, 50),
    lightaltitude = c(10, 80, 10, 80),
    # All it takes is accidentally interacting with a render that takes
    # hours in total to decide you NEVER want it interactive
    interactive = FALSE,
    # HDR lighting used to light the scene
    # environment_light = "assets/env/phalzer_forest_01_4k.hdr",
    # # environment_light = "assets/env/small_rural_road_4k.hdr",
    # # Adjust this value to brighten or darken lighting
    # intensity_env = 1.5,
    # # Rotate the light -- positive values move it counter-clockwise
    # rotate_env = 130,
    # This effectively sets the resolution of the final graphic,
    # because you increase the number of pixels here.
    # width = round(6000 * wr), height = round(6000 * hr),
    width = 8000, height = 8000
  )
  end_time <- Sys.time()
  cat(glue("Total time: {end_time - start_time}"), "\n")
}
