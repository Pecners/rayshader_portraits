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

pal <- "golden_brown"

c1 <- natparks.pals("Acadia", n = 10)
c2 <- natparks.pals("Redwood", n = 10)

colors <- c(lighten(c2[1], .75),
            lighten(c2[1], .5),
            lighten(c2[1], .25), 
            c2[1], c1[10:6])

swatchplot(colors)

texture <- grDevices::colorRampPalette(colors[9:5], bias = .5)(256)
lc <- colors[1]

outfile <- glue("images/blank/{env}_{intensity}_{rotate_environment}.png")

if (!file.exists(outfile)) {
  png::writePNG(matrix(1), outfile)
}
mat <- matrix(data = rep(0, 10000), nrow = 100, ncol = 100)

try(rgl::rgl.close())

mat |> 
  height_shade() |> 
  plot_3d(heightmap = mat, 
          windowsize = c(800,800), 
          shadowdepth = 1,
          solid = FALSE,
          z = 10,
          # This is the azimuth, like the angle of the sun.
          # 90 degrees is directly above, 0 degrees is a profile view.
          phi = 90, 
          zoom = 1, 
          # `theta` is the rotations of the map. Keeping it at 0 will preserve
          # the standard (i.e. north is up) orientation of a plot
          theta = 0, 
          background = "white") 


{
  start_time <- Sys.time()
  cat(glue("Start Time: {start_time}"), "\n")
  render_highquality(
    # We test-wrote to this file above, so we know it's good
    outfile, 
    # See rayrender::render_scene for more info, but best
    # sample method ('sobol') works best with values over 256
    samples = 450, 
    # Turn light off because we're using environment_light
    light = TRUE,
    # lightdirection = rev(c(95, 95, 85, 85)),
    lightdirection = rev(c(265, 265, 275, 275)),
    lightcolor = c(colors[3], lc, lighten(colors[7], .25), lc),
    lightintensity = c(500, 75, 750, 75),
    lightaltitude = c(10, 80, 10, 80),
    # All it takes is accidentally interacting with a render that takes
    # hours in total to decide you NEVER want it interactive
    interactive = FALSE,
    preview = FALSE,
    # HDR lighting used to light the scene
    environment_light = "assets/env/phalzer_forest_01_4k.hdr",
    # environment_light = "assets/env/small_rural_road_4k.hdr",
    # Adjust this value to brighten or darken lighting
    intensity_env = .5,
    # Rotate the light -- positive values move it counter-clockwise
    rotate_env = rotate_environment,
    # This effectively sets the resolution of the final graphic,
    # because you increase the number of pixels here.
    # width = round(6000 * wr), height = round(6000 * hr),
    width = 6000, height = 6000,
    ground_material = rayrender::diffuse(color = colors[3], noisecolor = colors[1])
  )
  end_time <- Sys.time()
  cat(glue("Total time: {end_time - start_time}"))
  }
