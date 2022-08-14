library(osmdata)
library(sf)
library(tidyverse)
library(elevatr)
library(rayshader)
library(glue)
library(NatParksPalettes)
source("R/utils/height_shade2.R")

###################################
# Set up polygon for clipping DEM #
###################################

# Set map name that will be used in file names, and 
# to get get boundaries from master NPS list

map <- "colorado_70"

t <- opq("Colorado") %>%
  add_osm_feature(key = "highway", value = "motorway") %>%
  osmdata_sf()

data <- t$osm_lines

no_tunnel <- t$osm_lines %>% 
  filter(!str_detect(alt_name, "Tunnel") | is.na(alt_name))

bbox <- st_bbox(data)
bbox["xmax"] <- -105.75
bbox["xmin"] <- -106.5

bbox_sf <- st_as_sfc(bbox)

data %>%
  ggplot() +
  geom_sf() +
  geom_sf(data = bbox_sf, fill = NA, color = "red")

clipped <- st_intersection(data, bbox_sf) %>% 
  st_union()
clipped_no_tunnel <- st_intersection(no_tunnel, bbox_sf) %>% 
  st_union()

# Plot to review

buffered <- clipped %>% 
  st_transform(crs = 6427) %>% 
  st_buffer(1609.34 * 1)

b2 <- clipped_no_tunnel %>% 
  st_transform(crs = 6427) %>% 
  st_buffer(1609.34 * .0125)

buffered %>% 
  ggplot() +
  geom_sf()

b2 %>% 
  ggplot() +
  geom_sf()

################
# Download DEM #
################

# Get DEM using `elevatr` package. Larger Z value (max is 14)
# results in greater resolution. Higher resolution takes more compute, though -- 
# I can't always max `z` up to 14 on my machine. 

z <- 13
zelev <- get_elev_raster(buffered, z = z, clip = "location")
zelev2 <- get_elev_raster(b2, z = z, clip = "location")
mat <- raster_to_matrix(zelev)
mat2 <- raster_to_matrix(zelev2)

dim_diff <- dim(mat) - dim(mat2)
wide <- cbind(matrix(nrow = nrow(mat2), ncol = round(dim_diff[2]/2)),
      mat2,
      matrix(nrow = nrow(mat2), ncol = round(dim_diff[2]/2))) 

matched <- rbind(matrix(ncol = ncol(wide), nrow = round(dim_diff[1]/2)),
              wide,
              matrix(ncol = ncol(wide), nrow = round(dim_diff[1]/2))) 


# When initially building your object to render, you'll want to work with
# slimmed down data so you can iterate faster. I prefer to just start with
# a `z` value of 10 above, but an alternative is to create a smaller matrix
# with rayshader::resize_matrix().

# small <- resize_matrix(mat, .25)

# Set up color palette. The `pal` argument will be used in file names,
# so it's important. `colors` will also be passed along. 

pal <- "alaska_flag"
#3871ef light blue
#061B4A true blue from flag
colors <- c("#061B4A", "#3871ef", "#FFB70B", "white")



# Calculate the aspect ratio of the plot so you can translate the dimensions

w <- nrow(mat)
h <- ncol(mat)

# Scale so longer side is 1

wr <- w / max(c(w,h))
hr <- h / max(c(w,h))

hs <- height_shade2(heightmap = mat,
                    heightmap2 = matched,
                    texture1 = grDevices::colorRampPalette(colors)(256),
                    texture2 = "white")

rm(zelev)
rm(zelev2)
rm(mat2)
rm(wide)
rm(matched)
###################
# Build 3D Object #
###################


# Keep this line so as you're iterating you don't forget to close the
# previous window

rgl::rgl.close()

# Create the initial 3D object


plot_3d(heightmap = mat, hillshade = hs,
        # This is my preference, I don't love the `solid` in most cases
        solid = FALSE, 
        # You might need to hone this in depending on the data resolution;
        # lower values exaggerate the height
        z = 4,
        # Set the location of the shadow, i.e. where the floor is.
        # This is on the same scale as your data, so call `zelev` to see the
        # min/max, and set it however far below min as you like.
        shadowdepth = 2000, 
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
render_camera(phi = 60, zoom = .5, theta = 0)

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
), "R/portraits/bryce_canyon/header.rds")

# Wrap this in brackets so it runs as chunk
{
  # Test write a PNG to ensure the file path is good.
  # You don't want `render_highquality()` to fail after it's 
  # taken hours to render.
  png::writePNG(matrix(1), outfile)
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
    # HDR lighting used to light the scene
    environment_light = "../bathybase/env/phalzer_forest_01_4k.hdr",
    # Adjust this value to brighten or darken lighting
    intensity_env = 1.75,
    # Rotate the light -- positive values move it counter-clockwise
    #rotate_env = 90,
    # This effectively sets the resolution of the final graphic,
    # because you increase the number of pixels here.
    width = 6000 * wr,
    height = 6000 * hr
  )
  end_time <- Sys.time()
  cat(glue("Total time: {end_time - start_time}"))
}



