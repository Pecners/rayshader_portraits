library(tidyverse)
library(magick)
library(glue)
library(colorspace)

# Load `header` list with needed data
header <- readRDS("R/portraits/nc_vice/header.rds")
colors <- header$colors
swatchplot(colors)

text_color <- colors[1] |> 
  darken(.35)

img <- image_read(header$outfile)

 

image_read("images/nc_vice/titled_nc_vice_pop_done.png") |> 
  image_scale(geometry = "41%x") |> 
  image_write("tracked_graphics/titled_nc_vice_pop_small.png")

# east
image_read("images/nc_vice/titled_nc_vice_pop_done.png") |> 
  image_crop(gravity = "center", geometry = "3000x2000+3000-1000") |> 
  image_write("images/nc_vice/titled_nc_east.png")

# central
image_read("images/nc_vice/titled_nc_vice_pop_done.png") |> 
  image_crop(gravity = "center", geometry = "3000x2000") |> 
  # image_annotate(gravity = "center", text = "Charlotte",
  #                location = "-300+100", 
  #                color = colors[8],
  #                font = "Rock Salt", size = 100) |> 
  image_write("images/nc_vice/titled_nc_central.png")

image_read("images/nc_vice/titled_nc_vice_pop_done.png") |> 
  image_crop(gravity = "west", geometry = "3000x2000+200+700") |> 
  image_write("images/nc_vice/titled_nc_west.png")

