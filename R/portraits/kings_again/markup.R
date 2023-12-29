library(tidyverse)
library(magick)
library(glue)
library(colorspace)

# Load `header` list with needed data
header <- readRDS("R/portraits/kings_again/header.rds")
colors <- header$colors
swatchplot(colors)

text_color <- colors[4]

img <- image_read(header$outfile)
image_info(img)

# s <- darken("#9a9397", .1)
# 
# shadow <- "#9a9397"
# inset <- image_read("images/kings_again/tam_inset.png")


img |> 
  image_crop(geometry = "5000x5000+0+0", gravity = "west") |> 
  image_annotate(text = "KINGS", 
                 gravity = "northwest",
                 location = "+300+700", font = "Poller One",
                 color = text_color, kerning = 50,
                 size = 400, weight = 700) |> 
  image_annotate(text = "CANYON", 
                 gravity = "northwest",
                 location = "+300+1200", font = "Poller One",
                 color = text_color, kerning = 10,
                 size = 400, weight = 700) |> 
  image_annotate(text = "NATIONAL PARK",
                 gravity = "northwest",
                 location = "+300+1700", font = "Amarante",
                 color = colors[8], kerning = 35,
                 weight = 700,
                 size = 250) |>
  image_annotate(text = glue("Graphic by Spencer Schien (@MrPecners) | ",
                             "Data from the National Park Service"),
                 gravity = "northwest",
                 location = "+300+2000", font = "Amarante",
                 color = colors[8],
                 kerning = 4,
                 size = 54) |>
  # image_composite(image_scale(inset, geometry = "75%x"),
  #                 gravity = "southwest",
  #                 offset = "+500+750") |> 
  image_write("images/kings_again/titled_kings.png")

image_read("images/kings_again/titled_kings.png") |> 
  image_scale(geometry = "68%x") |> 
  image_write("tracked_graphics/titled_kings_small.png")
