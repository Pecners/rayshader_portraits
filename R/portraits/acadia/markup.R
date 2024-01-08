library(tidyverse)
library(magick)
library(glue)
library(colorspace)

# Load `header` list with needed data
header <- readRDS("R/portraits/acadia/header.rds")
colors <- header$colors
swatchplot(colors)

text_color <- colors[1]

img <- image_read(header$outfile)
image_info(img)

# s <- darken("#9a9397", .1)
# 
# shadow <- "#9a9397"
# inset <- image_read("images/acadia/tam_inset.png")


img |> 
  image_crop(geometry = "6000x6000+0+0", gravity = "center") |> 
  image_annotate(text = "ACADIA",
                 gravity = "center",
                 location = "+0+500", font = "Poller One",
                 color = colors[8], kerning = 350,
                 size = 700, weight = 700) |>
  image_annotate(text = "NATIONAL",
                 gravity = "center",
                 location = "-1500-300", font = "Amarante",
                 color = colors[2], kerning = 100,
                 weight = 700,
                 size = 350) |>
  image_annotate(text = "PARK",
                 gravity = "center",
                 location = "+1250+1250", font = "Amarante",
                 color = colors[2], kerning = 600,
                 weight = 700,
                 size = 350) |>
  image_annotate(text = glue("Graphic by Spencer Schien (@MrPecners) | ",
                             "Data from AWS Terrain Tiles"),
                 gravity = "center",
                 location = "+0+820", font = "Amarante",
                 color = colors[7],
                 kerning = 43,
                 size = 70) |>
  # image_composite(image_scale(inset, geometry = "75%x"),
  #                 gravity = "southwest",
  #                 offset = "+500+750") |> 
  image_write("images/acadia/titled_acadia.png")



image_read("images/acadia/titled_acadia.png") |> 
  image_scale(geometry = "46%x") |> 
  image_write("tracked_graphics/titled_acadia_small.png")

image_read("images/new_mexico/titled_nm_pop.png") |> 
  image_scale(geometry = "46%x") |> 
  image_write("tracked_graphics/titled_nm_pop_small.png")
