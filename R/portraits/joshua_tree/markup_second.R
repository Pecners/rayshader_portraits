library(tidyverse)
library(magick)
library(glue)
library(colorspace)

# Load `header` list with needed data
header <- readRDS("R/portraits/joshua_tree/header.rds")
colors <- header$colors
swatchplot(colors)

text_color <- colors[4]

img <- image_read(header$outfile)
image_info(img)

# s <- darken("#9a9397", .1)
# 
# shadow <- "#9a9397"
# inset <- image_read("images/sequoia/tam_inset.png")


img |> 
  image_crop(geometry = "6000x5500+0-500", gravity = "CENTER") |> 
  image_annotate(text = "JOSHUA TREE", 
                 gravity = "north",
                 location = "+0+300", font = "Poller One",
                 color = text_color, kerning = 100,
                 size = 400, weight = 700) |> 
  # image_annotate(text = "CANYON", 
  #                gravity = "northwest",
  #                location = "+300+1200", font = "Poller One",
  #                color = text_color, kerning = 10,
  #                size = 400, weight = 700) |> 
  image_annotate(text = "NATIONAL PARK",
                 gravity = "north",
                 location = "+0+950", font = "Amarante",
                 color = colors[8], kerning = 75,
                 weight = 700,
                 size = 400) |>
  image_annotate(text = glue("Graphic by Spencer Schien (@MrPecners) | ",
                             "Data from the National Park Service"),
                 gravity = "north",
                 location = "+0+1375", font = "Amarante",
                 color = colors[8],
                 kerning = 18,
                 size = 65) |>
  # image_composite(image_scale(inset, geometry = "75%x"),
  #                 gravity = "southwest",
  #                 offset = "+500+750") |> 
  image_write("images/joshua_tree/titled_jt.png")

image_read("images/joshua_tree/titled_jt.png") |> 
  image_scale(geometry = "61%x") |> 
  image_write("tracked_graphics/titled_jt_small.png")
