library(tidyverse)
library(rayshader)
library(glue)
library(colorspace)
library(NatParksPalettes)

# Source image below
# https://www.nasa.gov/feature/goddard/2022/nasa-s-webb-catches-fiery-hourglass-as-new-star-forms
map <- "young_stellar_object"


img <- raster::raster("assets/young_stellar_object.png")
ping <- png::readPNG("assets/young_stellar_object.png")
dimnames(ping) <- list(NULL, NULL, c("Red", "Green", "Blue"))
mat <- raster_to_matrix(img)

mat[mat < 75] <- NA
smat <- rayshader::resize_matrix(mat, .25)


pal <- "golden_brown"

c1 <- natparks.pals("Acadia", n = 10)
c2 <- natparks.pals("Redwood", n = 10)

colors <- c(lighten(c2[1], .75),
            lighten(c2[1], .5),
            lighten(c2[1], .25), 
            c2[1], c1[10:6])

swatchplot(colors)



texture <- grDevices::colorRampPalette(colors[9:5], bias = .5)(256)

swatchplot(texture)

###################
# Build 3D Object #
###################

# setting shadow to 500 feet below minimum value in DEM
shadow_depth <- min(mat, na.rm = TRUE)

# setting resolution to about 5x for height
res <- 5

# Keep this line so as you're iterating you don't forget to close the
# previous window

try(rgl::rgl.close())

# Create the initial 3D object

mat %>%
  # This adds the coloring, we're passing in our `colors` object
  height_shade() %>%
  add_overlay(overlay = png::readPNG("assets/young_stellar_object.png")) |> 
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
render_camera(phi = 75, zoom = .6, theta = 0)

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
    lightdirection = rev(c(125, 125, 135, 135)),
    lightcolor = c(colors[3], colors[9], colors[7], colors[9]),
    lightintensity = c(500, 75, 750, 75),
    lightaltitude = c(10, 80, 10, 80),
    # All it takes is accidentally interacting with a render that takes
    # hours in total to decide you NEVER want it interactive
    interactive = FALSE,
    # scene_elements = map2_df(c(-1.5, 1.05),
    #                          c(.6, .6),
    #                          function(i, j) {
    #   rayrender::add_object(
    #     rayrender::sphere(z=ncol(mat) * .15 * j,
    #                       y= 150,
    #                       x= nrow(mat) * .15 * i,
    #                       radius= nrow(mat) * .005,
    #                       material=rayrender::light(color=colors[7],
    #                                                 intensity=2000))
    #   )
    # }),
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
    width = 8000, height = 8000,
    ground_material = rayrender::diffuse(color = colors[3], noisecolor = colors[1])
  )
  end_time <- Sys.time()
  cat(glue("Total time: {end_time - start_time}"), "\n")
}
