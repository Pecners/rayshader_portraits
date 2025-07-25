library(sf)
library(tidyverse)
library(elevatr)
library(rayshader)
library(glue)
library(colorspace)
library(tigris)
library(stars)
library(MetBrewer)
library(rnaturalearth)
library(NatParksPalettes)

# Set map name that will be used in file names, and 
# to get get boundaries from master NPS list

map <- "usa"

# Kontur data source: https://data.humdata.org/organization/kontur
kf <- "data/kontur/kontur_population_US_20231101.gpkg"
d_layers <- st_layers(kf)
d_crs <- d_layers[["crs"]][[1]][[2]]

s <- states() |>
  st_transform(crs = d_crs)

not_states <- c("Commonwealth of the Northern Mariana Islands",
                "Alaska",
                "Puerto Rico",
                "Hawaii",
                "American Samoa",
                "Guam",
                "United States Virgin Islands")

ss <- s |> 
  filter(!NAME %in% not_states)

gl <- ne_download(type = "lakes", category = "physical", scale = "large")  %>%
  st_as_sf() %>%
  st_transform(., crs = st_crs(ss))

l <- ne_download(type = "land", category = "physical", scale = "large")  %>%
  st_as_sf() %>%
  st_transform(., crs = st_crs(ss))

# gl now has a lot of lakes, need to specify our 
# Great Lakes

lakes <- c("Lake Erie",
           "Lake Michigan",
           "Lake Superior",
           "Lake Huron",
           "Lake Ontario")

gl <- gl %>%
  filter(name %in% lakes) %>%
  st_transform(crs = st_crs(ss)) 

s_bord <- st_difference(ss, st_union(gl)) |> 
  st_intersection(l) |> 
  st_transform(crs = 3347)

s_bord |> 
  ggplot() +
  geom_sf()
# 
# st <- s |> 
#   filter(NAME == str_to_title(str_replace_all("usa", "_", " ")))
# 
# wkt_st <- st_as_text(st[[1,"geometry"]])

data <- st_read("data/kontur/kontur_population_US_20231101.gpkg")

# data |> 
#   ggplot() +
#   geom_sf()

one_states <- st_union(ss) |> 
  st_as_sf()

wkt_st <- st_as_text(one_states[[1,"x"]])

st_d <- st_read(kf, wkt_filter = wkt_st)
st_d <- st_transform(st_d, crs = 3347)

# st_d |> 
#   ggplot() +
#   geom_sf()

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

size <- 10000
rast <- st_rasterize(st_d |> 
                       select(population, geom),
                     nx = floor(size * x_rat), ny = floor(size * y_rat))


mat <- matrix(rast$population, nrow = floor(size * x_rat), ncol = floor(size * y_rat))

# set up color palette

pal <- "hiroshige"
c1 <- met.brewer("Hiroshige")
colors <- c1[c(5:1, 10:6)] |> rev()
swatchplot(colors)

texture <- grDevices::colorRampPalette(c1[5:1], bias = 2)(256)

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
          # z = 50 / (size / 3000), this was the 10k version
          z = 30,
          # Set the location of the shadow, i.e. where the floor is.
          # This is on the same scale as your data, so call `zelev` to see the
          # min/max, and set it however far below min as you like.
          shadowdepth = 0,
          # Set the window size relatively small with the dimensions of our data.
          # Don't make this too big because it will just take longer to build,
          # and we're going to resize with `render_highquality()` below.
          windowsize = c(800*x_rat,800*y_rat), 
          # This is the azimuth, like the angle of the sun.
          # 90 degrees is directly above, 0 degrees is a profile view.
          phi = 90, 
          zoom = 1, 
          # `theta` is the rotations of the map. Keeping it at 0 will preserve
          # the standard (i.e. north is up) orientation of a plot
          theta = 0, 
          background = "white") 

# Use this to adjust the view after building the window object
render_camera(phi = 50, zoom = .55, theta = 0)

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
    lightdirection = rev(c(150, 150, 140, 140)),
    lightcolor = c(colors[3], "white", colors[7], "white"),
    lightintensity = c(750, 50, 1000, 50),
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
    width = 10000*x_rat, height = 10000*y_rat,
    ground_material = rayrender::microfacet(roughness = .4,
                                            eta = c(1, .75, .1), 
                                            kappa = c(.1, .75, 1))
  )
  end_time <- Sys.time()
  cat(glue("Total time: {end_time - start_time}"), "\n")
}
