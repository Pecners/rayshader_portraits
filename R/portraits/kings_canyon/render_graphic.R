library(sf)
library(tidyverse)
library(elevatr)
library(rayshader)
library(glue)
library(colorspace)
library(NatParksPalettes)

###################################
# Set up polygon for clipping DEM #
###################################

# Set map name that will be used in file names, and 
# to get get boundaries from master NPS list

map <- "kings_canyon"

data <- st_read("data/nps_boundary/nps_boundary.shp") |>
  filter(str_detect(PARKNAME, str_to_title(str_replace(map, "_", " "))))

# Plot to review
data |>
  ggplot() +
  geom_sf()

################
# Download DEM #
################

# Get DEM using `elevatr` package. Larger Z value (max is 14)
# results in greater resolution. Higher resolution takes more compute, though -- 
# I can't always max `z` up to 14 on my machine. 

z <- 13
zelev <- get_elev_raster(data, z = z, clip = "location")
mat <- raster_to_matrix(zelev)

# When initially building your object to render, you'll want to work with
# slimmed down data so you can iterate faster. I prefer to just start with
# a `z` value of 10 above, but an alternative is to create a smaller matrix
# with rayshader::resize_matrix().

# small <- resize_matrix(mat, .25)

# Set up color palette. The `pal` argument will be used in file names,
# so it's important. `colors` will also be passed along. 


pal <- "glacier_arches2"

c1 <- natparks.pals("Olympic")
c2 <- natparks.pals("Arches2")

colors <- c(c1[6:5], "white")
colorspace::swatchplot(colors)

# Calculate the aspect ratio of the plot so you can translate the dimensions

w <- nrow(mat)
h <- ncol(mat)

# Scale so longer side is 1

wr <- w / max(c(w,h))
hr <- h / max(c(w,h))

###################
# Build 3D Object #
###################


# Keep this line so as you're iterating you don't forget to close the
# previous window

try(rgl::rgl.close())

# Create the initial 3D object

mat %>%
  # This adds the coloring, we're passing in our `colors` object
  height_shade(texture = grDevices::colorRampPalette(rev(colors), bias = .75)(256)) %>%
  plot_3d(heightmap = mat, 
          # This is my preference, I don't love the `solid` in most cases
          solid = FALSE,
          # You might need to hone this in depending on the data resolution;
          # lower values exaggerate the height
          z = 8,
          # Set the location of the shadow, i.e. where the floor is.
          # This is on the same scale as your data, so call `zelev` to see the
          # min/max, and set it however far below min as you like.
          shadowdepth = -1000,
          # Set the window size relatively small with the dimensions of our data.
          # Don't make this too big because it will just take longer to build,
          # and we're going to resize with `render_highquality()` below.
          windowsize = c(800*wr,800*hr), 
          # This is the azimuth, like the angle of the sun.
          # 90 degrees is directly above, 0 degrees is a profile view.
          phi = 90, 
          zoom = 1, 
          # `theta` is the rotations of the map. Keeping it at 0 will preserve
          # the standard (i.e. north is up) orientation of a plot
          theta = 0, 
          background = "white") 

# Use this to adjust the view after building the window object
render_camera(phi = 80, zoom = 1, theta = 0)

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
outfile <- str_to_lower(glue("images/{map}/{map}_{pal}_z{z}.png"))

# Now that everything is assigned, save these objects so we
# can use then in our markup script
saveRDS(list(
  map = map,
  pal = pal,
  z = z,
  colors = colors,
  outfile = outfile
), glue("R/portraits/{map}/header.rds"))

# Wrap this in brackets so it runs as chunk
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
    samples = 300, 
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
    intensity_env = 1.25,
    # Rotate the light -- positive values move it counter-clockwise
    rotate_env = 160,
    # This effectively sets the resolution of the final graphic,
    # because you increase the number of pixels here.
    width = round(6000 * wr), height = round(6000 * hr),
    # default ground material is diffuse white, here using
    # microfacet instead to create a brushed metal appearance
    ground_material = rayrender::microfacet(roughness = c(.1, .3),
                                            eta=c(10,7,10), kappa=c(.5,.5,.5))
  )
  end_time <- Sys.time()
  cat(glue("Total time: {end_time - start_time}"))
}



