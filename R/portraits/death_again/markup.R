library(tidyverse)
library(magick)
library(glue)
library(colorspace)

# Load `header` list with needed data
header <- readRDS("R/portraits/death_again/header.rds")
colors <- header$colors
swatchplot(colors)

text_color <- colors[4]

img <- image_read(header$outfile)
image_info(img)

# s <- darken("#9a9397", .1)
# 
# shadow <- "#9a9397"
# inset <- image_read("images/death_again/tam_inset.png")


img |> 
  image_crop(geometry = "5000x5000+0+0", gravity = "east") |> 
  image_annotate(text = "DEATH VALLEY", 
                 gravity = "north",
                 location = "+800+800", font = "Poller One",
                 color = text_color, kerning = 50,
                 size = 250, weight = 700) |> 
  image_annotate(text = "NATIONAL PARK",
                 gravity = "north",
                 location = "+1100+1400", font = "Amarante",
                 color = colors[8], kerning = 25,
                 weight = 700,
                 size = 250) |>
  image_annotate(text = glue("Graphic by Spencer Schien (@MrPecners) | ",
                             "Data from the National Park Service"),
                 gravity = "north",
                 location = "+1100+1700", font = "Amarante",
                 color = colors[8],
                 kerning = 6,
                 size = 45) |>
  # image_composite(image_scale(inset, geometry = "75%x"),
  #                 gravity = "southwest",
  #                 offset = "+500+750") |> 
  image_write("images/death_again/titled_dv.png")

image_read("images/death_again/titled_dv.png") |> 
  image_scale(geometry = "69%x") |> 
  image_write("tracked_graphics/titled_dv_small.png")
