library(tidyverse)
library(rayshader)
library(glue)
library(colorspace)
library(scico)


###################################
# Set up polygon for clipping DEM #
###################################

# Set map name that will be used in file names, and 
# to get get boundaries from master NPS list

map <- "death_pillars"


img <- raster::raster("assets/pillars_of_creation.png")
mat <- raster_to_matrix(img)

raster::plot(img)

# Set up color palette. The `pal` argument will be used in file names,
# so it's important. `colors` will also be passed along. 


pal <- "gray_jolla"

c1 <- scico(palette = "grayC", n = 5)
c2 <- scico(palette = "lajolla", n = 5)
colors <- c(c1[c(1,4)], rev(c2[1:4]))

swatchplot(colors)

texture <- grDevices::colorRampPalette(colors)(256)

swatchplot(texture)

###################
# Build 3D Object #
###################

# setting shadow to 500 feet below minimum value in DEM
shadow_depth <- min(mat, na.rm = TRUE) - 1000

# setting resolution to about 5x for height
res <- 5

# Keep this line so as you're iterating you don't forget to close the
# previous window

try(rgl::rgl.close())

# Create the initial 3D object

mat %>%
  # This adds the coloring, we're passing in our `colors` object
  height_shade(texture = grDevices::colorRampPalette(colors)(256)) %>%
  plot_3d(heightmap = mat,
          # This is my preference, I don't love the `solid` in most cases
          solid = FALSE,
          # You might need to hone this in depending on the data resolution;
          # lower values exaggerate the height
          z = res,
          # Set the location of the shadow, i.e. where the floor is.
          # This is on the same scale as your data, so call `zelev` to see the
          # min/max, and set it however far below min as you like.
          shadowdepth = shadow_depth,
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
render_camera(phi = 90, zoom = 1.25, theta = 0)

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
outfile <- str_to_lower(glue("images/{map}/{map}_{pal}_z{res}.png"))

# Now that everything is assigned, save these objects so we
# can use then in our markup script
saveRDS(list(
  map = map,
  pal = pal,
  z = res,
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
    light = FALSE, 
    # All it takes is accidentally interacting with a render that takes
    # hours in total to decide you NEVER want it interactive
    interactive = FALSE,
    preview = FALSE,
    # HDR lighting used to light the scene
    environment_light = "assets/env/phalzer_forest_01_4k.hdr",
    # environment_light = "assets/env/small_rural_road_4k.hdr",
    # Adjust this value to brighten or darken lighting
    intensity_env = 2,
    # Rotate the light -- positive values move it counter-clockwise
    rotate_env = -20,
    # This effectively sets the resolution of the final graphic,
    # because you increase the number of pixels here.
    # width = round(6000 * wr), height = round(6000 * hr),
    width = 6000, height = 6000
  )
  end_time <- Sys.time()
  cat(glue("Total time: {end_time - start_time}"))
}




