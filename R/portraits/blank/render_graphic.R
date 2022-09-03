library(sf)
library(tidyverse)
library(elevatr)
library(rayshader)
library(glue)
library(colorspace)
library(NatParksPalettes)
library(scico)
library(rayrender)

intensity <- 1.5
rotate_environment <- -20
env <- "forest"

outfile <- glue("images/blank/{env}_{intensity}_{rotate_environment}.png")

if (!file.exists(outfile)) {
  png::writePNG(matrix(1), outfile)
}

rayrender::generate_ground(material = diffuse()) |> 
  rayrender::render_scene(environment_light = "assets/env/phalzer_forest_01_4k.hdr",
                          width = 6000,
                          height = 6000,
                          samples = 300, 
                          # this lookat results in the ground filling the frame
                          lookat = c(0,-5,0),
                          intensity_env = intensity,
                          # Rotate the light -- positive values move it counter-clockwise
                          rotate_env = rotate_environment, 
                          filename = outfile)

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
    intensity_env = 1.5,
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




