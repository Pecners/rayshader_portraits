library(tidyverse)
library(magick)
library(glue)
library(colorspace)

# Load `header` list with needed data
header <- readRDS("R/portraits/yosemite_again/header.rds")
colors <- header$colors
swatchplot(colors)

text_color <- colors[4]

img <- image_read(header$outfile)
image_info(img)

# s <- darken("#9a9397", .1)
# 
# shadow <- "#9a9397"
# inset <- image_read("images/yosemite_again/tam_inset.png")


img |> 
  image_crop(geometry = "5000x5600+0-500", gravity = "east") |> 
  image_annotate(text = "YOSEMITE", 
                 gravity = "north",
                 location = "+900+300", font = "Poller One",
                 color = text_color, kerning = 50,
                 size = 300, weight = 700) |> 
  # image_annotate(text = "CANYON", 
  #                gravity = "northwest",
  #                location = "+300+1200", font = "Poller One",
  #                color = text_color, kerning = 10,
  #                size = 400, weight = 700) |> 
  image_annotate(text = "NATIONAL PARK",
                 gravity = "north",
                 location = "+900+700", font = "Amarante",
                 color = colors[8], kerning = 30,
                 weight = 700,
                 size = 250) |>
  image_annotate(text = glue("Graphic by Spencer Schien (@MrPecners) | ",
                             "Data from the National Park Service"),
                 gravity = "north",
                 location = "+900+975", font = "Amarante",
                 color = colors[8],
                 kerning = 5,
                 size = 47) |>
  # image_composite(image_scale(inset, geometry = "75%x"),
  #                 gravity = "southwest",
  #                 offset = "+500+750") |> 
  image_write("images/yosemite_again/titled_yosemite.png")

image_read("images/yosemite_again/titled_yosemite.png") |> 
  image_scale(geometry = "63%x") |> 
  image_write("tracked_graphics/titled_yosemite_small.png")
