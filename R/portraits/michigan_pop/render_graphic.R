library(sf)
library(tidyverse)
library(elevatr)
library(rayshader)
library(glue)
library(colorspace)
library(PrettyCols)
library(tigris)
library(stars)

###################################
# Set up polygon for clipping DEM #
###################################

# Set map name that will be used in file names, and 
# to get get boundaries from master NPS list

map <- "michigan_pop"

# Kontur data source: https://data.humdata.org/dataset/kontur-population-united-states-of-america

data <- st_read("data/kontur_population_US_20220630.gpkg")

s <- states() |> 
  st_transform(crs = st_crs(data))

st <- s |> 
  filter(NAME == "Michigan")

st |> 
  ggplot() +
  geom_sf()


st_d <- st_intersection(data, st)


bb <- st_bbox(st_d)
yind <- st_distance(st_point(c(bb[["xmin"]], bb[["ymin"]])), 
                    st_point(c(bb[["xmin"]], bb[["ymax"]])))
xind <- st_distance(st_point(c(bb[["xmin"]], bb[["ymin"]])), 
                    st_point(c(bb[["xmax"]], bb[["ymin"]])))

size <- 2500
rast <- st_rasterize(st_d |> 
                       select(population, geom),
                     nx = floor(size * (xind/yind)), ny = size)


mat <- matrix(rast$population, nrow = floor(size * (xind/yind)), ncol = size)

pal <- "pink_greens"

c1 <- prettycols("PinkGreens")
colors <- c(c1[c(6:8, 1:4)])
swatchplot(colors)

texture <- grDevices::colorRampPalette(colors, bias = 2)(256)

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
          solid = FALSE,
          soliddepth = 0,
          # You might need to hone this in depending on the data resolution;
          # lower values exaggerate the height
          z = 25,
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
render_camera(phi = 50, zoom = .75, theta = -20)

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
    samples = 400, 
    # Turn light off because we're using environment_light
    light = TRUE,
    lightdirection = 290,
    lightcolor = c("white", "#fff5b6"),
    lightintensity = c(400, 200),
    lightaltitude = c(20, 80),
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
    width = 6000, height = 6000
  )
  end_time <- Sys.time()
  cat(glue("Total time: {end_time - start_time}"))
}




