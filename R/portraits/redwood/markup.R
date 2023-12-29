library(tidyverse)
library(magick)
library(glue)
library(colorspace)

# Load `header` list with needed data
header <- readRDS("R/portraits/redwood/header.rds")
colors <- header$colors
swatchplot(colors)

text_color <- colors[4]

img <- image_read(header$outfile)
image_info(img)

# s <- darken("#9a9397", .1)
# 
# shadow <- "#9a9397"
# inset <- image_read("images/redwood/tam_inset.png")


img |> 
  image_crop(geometry = "5000x6000-200+0", gravity = "center") |> 
  image_annotate(text = "RED", 
                 gravity = "center",
                 location = "-1200-800", font = "Poller One",
                 color = text_color, kerning = 100,
                 size = 400, weight = 700) |> 
  image_annotate(text = "WOOD",
                 gravity = "center",
                 location = "+1000-800", font = "Poller One",
                 color = text_color, kerning = 50,
                 size = 400, weight = 700) |>
  image_annotate(text = "NATIONAL",
                 gravity = "center",
                 location = "-1000-200", font = "Amarante",
                 color = colors[8], kerning = 35,
                 weight = 700,
                 size = 250) |>
  image_annotate(text = "PARK",
                 gravity = "center",
                 location = "+800-200", font = "Amarante",
                 color = colors[8], kerning = 150,
                 weight = 700,
                 size = 250) |>
  image_annotate(text = "Graphic by Spencer Schien (@MrPecners)",
                 gravity = "center",
                 location = "-1000+0", font = "Amarante",
                 color = colors[8],
                 kerning = 8,
                 size = 54) |>
  image_annotate(text = "Data from the National Park Service",
                 gravity = "center",
                 location = "+800+0", font = "Amarante",
                 color = colors[8],
                 kerning = 4,
                 size = 54) |>
  # image_composite(image_scale(inset, geometry = "75%x"),
  #                 gravity = "southwest",
  #                 offset = "+500+750") |> 
  image_write("images/redwood/titled_redwood.png")

image_read("images/redwood/titled_redwood.png") |> 
  image_scale(geometry = "64%x") |> 
  image_write("tracked_graphics/titled_redwood_small.png")
