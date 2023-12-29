library(tidyverse)
library(magick)
library(glue)
library(colorspace)

# Load `header` list with needed data
header <- readRDS("R/portraits/lassen_volcanic/header.rds")
colors <- header$colors
swatchplot(colors)

text_color <- colors[4]

img <- image_read(header$outfile)
image_info(img)

# s <- darken("#9a9397", .1)
# 
# shadow <- "#9a9397"
# inset <- image_read("images/lassen_volcanic/tam_inset.png")


img |> 
  image_crop(geometry = "6000x5500+0-500", gravity = "CENTER") |> 
  image_annotate(text = "LASSEN VOLCANIC", 
                 gravity = "north",
                 location = "+0+400", font = "Poller One",
                 color = text_color, kerning = 50,
                 size = 350, weight = 700) |> 
  # image_annotate(text = "CANYON", 
  #                gravity = "northwest",
  #                location = "+300+1200", font = "Poller One",
  #                color = text_color, kerning = 10,
  #                size = 400, weight = 700) |> 
  image_annotate(text = "NATIONAL PARK",
                 gravity = "north",
                 location = "+0+850", font = "Amarante",
                 color = colors[8], kerning = 75,
                 weight = 700,
                 size = 300) |>
  image_annotate(text = glue("Graphic by Spencer Schien (@MrPecners) | ",
                             "Data from the National Park Service"),
                 gravity = "north",
                 location = "+0+1175", font = "Amarante",
                 color = colors[8],
                 kerning = 14,
                 size = 55) |>
  # image_composite(image_scale(inset, geometry = "75%x"),
  #                 gravity = "southwest",
  #                 offset = "+500+750") |> 
  image_write("images/lassen_volcanic/titled_lassen.png")

image_read("images/lassen_volcanic/titled_lassen.png") |> 
  image_scale(geometry = "63%x") |> 
  image_write("tracked_graphics/titled_lassen_small.png")
