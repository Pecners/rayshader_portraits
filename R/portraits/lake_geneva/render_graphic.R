library(sf)
library(tidyverse)
library(elevatr)
library(rayshader)
library(glue)
library(colorspace)
library(PrettyCols)
library(tigris)
library(stars)
library(rnaturalearth)
library(MetBrewer)
library(parallel)
library(doParallel)
library(magick)

codes <- c(
  "CH",
  "FR"
)

# Kontur data source: https://data.humdata.org/dataset/kontur-population-united-states-of-america

data <- map_df(codes, function(i) {
  st_read(glue("data/kontur/kontur_population_{i}_20220630.gpkg"))
})


# Set map name that will be used in file names

map <- "lake_geneva"

gl <- ne_download(type = "lakes", 
                  category = "physical", 
                  scale = 10)  |> 
  st_as_sf() 

riv <- gl |> 
  filter(str_detect(name_fr, "Léman"))

riv |> 
  ggplot() +
  geom_sf()


riv_buff <- riv |> 
  st_transform(crs = st_crs(data)) |> 
  st_buffer(25000) |> 
  st_union()

int <- st_intersects(data, riv_buff)

st_dd <- map_dbl(int, function(i) {
  if (length(i) > 0) {
    return(i)
  } else {
    return(0)
  }
})


st_d <- data[which(st_dd == 1),]

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

# convert to raster
size <- 1000
rast <- st_rasterize(st_d |> 
                       select(population, geom),
                     nx = floor(size * x_rat), ny = floor(size * y_rat))

# convert to matrix

mat <- matrix(rast$population, nrow = floor(size * x_rat), ncol = floor(size * y_rat))


# mat <- add_legend(m = mat, 
#                   x_start = .95,
#                   y_start = .25,
#                   width = .05,
#                   height = .15)

# make color palette

pal <- "hiroshige"
c1 <- met.brewer("Hiroshige")
colors <- c1[c(5:1, 10:6)] |> rev()
swatchplot(colors)

texture <- grDevices::colorRampPalette(colors, bias = 1.5)(256)

swatchplot(texture)

###################
# Build 3D Object #
###################

try(rgl::rgl.close())

# Create the initial 3D object

mat |> 
  height_shade(texture = texture) |> 
  plot_3d(heightmap = mat, 
          # This is my preference, I don't love the `solid` in most cases
          soliddepth = 0,
          solid = FALSE,
          # You might need to hone this in depending on the data resolution;
          # lower values exaggerate the height
          z = 15*8,
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

walk(seq(from = 1, to = 360, by = 2), function(a) {
  
  cat(crayon::red(glue("Angle {a}")), "\n")
  
  render_camera(phi = 45, zoom = 1, theta = a)
  
  
  ###############################
  # Create High Quality Graphic #
  ###############################
  
  # You should only move on if you have the object set up
  # as you want it, including colors, resolution, viewing position, etc.
  
  
  angle <- sprintf("%04s", a)
  
  # Set up outfile where graphic will be saved.
  # Note that I am not tracking the `images` directory, and this
  # is because these files are big enough to make tracking them on
  # GitHub difficult. 
  outfile <- str_to_lower(glue("images/{map}/z_{map}_{pal}_{angle}.png"))
  
  # Now that everything is assigned, save these objects so we
  # can use then in our markup script
  # saveRDS(list(
  #   map = map,
  #   pal = pal,
  #   colors = colors,
  #   outfile = outfile,
  #   coords = coords
  # ), glue("R/portraits/{map}/header.rds"))
  
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
      light = TRUE,
      lightdirection = rev(c(185, 185, 175, 175) - a),
      lightcolor = c(colors[3], "white", colors[7], "white"),
      lightintensity = c(750, 50, 1000, 50),
      lightaltitude = c(10, 80, 10, 80),
      # All it takes is accidentally interacting with a render that takes
      # hours in total to decide you NEVER want it interactive
      interactive = FALSE,
      preview = FALSE,
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
      width = 800, height = 800
    )
    end_time <- Sys.time()
    cat(glue("Total time: {end_time - start_time}"), "\n")
  }
})

# annotate frames

f <- list.files("images/lake_geneva")
no_vid <- f[which(!str_detect(f, ".mp4"))]

if (!dir.exists("images/lake_geneva/titled")) {
  dir.create("images/lake_geneva/titled")
}

walk(no_vid, function(v) {
  img <- image_read(glue("images/lake_geneva/{v}"))
  
  img |> 
    image_crop(geometry = "800x600+0+0", gravity = "center") |> 
    image_annotate(text = "POPULATION DENSITY AROUND", 
                   gravity = "north", 
                   location = "+10+10", font = "El Messiri",
                   color = text_color,
                   size = 15) |> 
    image_annotate(text = "Lake Geneva", gravity = "north",
                   location = "+10+30", font = "El Messiri",
                   color = text_color,
                   size = 60, weight = 700) |> 
    image_annotate(text = glue("Graphic by Spencer Schien (@MrPecners) | ",
                               "Kontur Population Data (Released June 30, 2022)"),
                   gravity = "south",
                   location = "+0+10", font = "El Messiri",
                   color = alpha(text_color, .5),
                   size = 10, weight = 700) |> 
    image_write(glue("images/lake_geneva/titled/{v}.png"))
})

# get annotated frames for video compilation

f_titled <- list.files("images/lake_geneva/titled")

moving <- no_vid[which(str_detect(f_titled, "z_"))]
ff <- c(
  paste0("images/lake_geneva/titled/", moving),
  paste0("images/lake_geneva/titled/", f_titled)
)
  

av::av_encode_video(ff, "images/lake_geneva/video/titled.mp4")
file.copy("images/lake_geneva/video/titled.mp4",
          "tracked_graphics/titled_lake_geneva.mp4")
