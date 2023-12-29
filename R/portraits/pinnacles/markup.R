library(tidyverse)
library(magick)
library(glue)
library(colorspace)

# Load `header` list with needed data
header <- readRDS("R/portraits/pinnacles/header.rds")
colors <- header$colors
swatchplot(colors)

text_color <- colors[4]

img <- image_read(header$outfile)
image_info(img)

# s <- darken("#9a9397", .1)
# 
# shadow <- "#9a9397"
# inset <- image_read("images/pinnacles/tam_inset.png")


img |> 
  image_crop(geometry = "5000x5600+0-500", gravity = "east") |> 
  image_annotate(text = "PINNACLES", 
                 gravity = "north",
                 location = "+600+300", font = "Poller One",
                 color = text_color, kerning = 50,
                 size = 350, weight = 700) |> 
  # image_annotate(text = "CANYON", 
  #                gravity = "northwest",
  #                location = "+300+1200", font = "Poller One",
  #                color = text_color, kerning = 10,
  #                size = 400, weight = 700) |> 
  image_annotate(text = "NATIONAL PARK",
                 gravity = "north",
                 location = "+600+750", font = "Amarante",
                 color = colors[8], kerning = 75,
                 weight = 700,
                 size = 300) |>
  image_annotate(text = glue("Graphic by Spencer Schien (@MrPecners) | ",
                             "Data from the National Park Service"),
                 gravity = "north",
                 location = "+600+1075", font = "Amarante",
                 color = colors[8],
                 kerning = 14,
                 size = 55) |>
  # image_composite(image_scale(inset, geometry = "75%x"),
  #                 gravity = "southwest",
  #                 offset = "+500+750") |> 
  image_write("images/pinnacles/titled_pinnacles.png")

image_read("images/pinnacles/titled_pinnacles.png") |> 
  image_scale(geometry = "63%x") |> 
  image_write("tracked_graphics/titled_pinnacles_small.png")
