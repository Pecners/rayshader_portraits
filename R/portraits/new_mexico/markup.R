library(tidyverse)
library(magick)
library(glue)
library(colorspace)

# Load `header` list with needed data
header <- readRDS("R/portraits/new_mexico/header.rds")
colors <- header$colors
swatchplot(colors)

text_color <- colors[1]

img <- image_read(header$outfile)


# s <- darken("#9a9397", .1)
# 
# shadow <- "#9a9397"
# inset <- image_read("images/new_mexico/tam_inset.png")


img |> 
  image_crop(geometry = "7500x8500+0-500", gravity = "center") |> 
  image_annotate(text = "NEW MEXICO", 
                 gravity = "north",
                 location = "+750+300", font = "Poller One",
                 color = text_color, kerning = 100,
                 size = 450, weight = 700) |> 
  image_annotate(text = "POPULATION DENSITY",
                 gravity = "north",
                 location = "+1250+1000", font = "Amarante",
                 color = colors[2], kerning = 50,
                 weight = 700,
                 size = 350) |>
  image_annotate(text = glue("Graphic by Spencer Schien (@MrPecners) | ",
                             "Kontur Population Data (Released June 30, 2022)"),
                 gravity = "north",
                 location = "+1245+1375", font = "Amarante",
                 color = colors[2],
                 kerning = 14,
                 size = 70) |>
  # image_composite(image_scale(inset, geometry = "75%x"),
  #                 gravity = "southwest",
  #                 offset = "+500+750") |> 
  image_write("images/new_mexico/titled_nm_pop.png")



image_read("images/new_mexico/titled_nm_pop.png") |> 
  image_scale(geometry = "46%x") |> 
  image_write("tracked_graphics/titled_nm_pop_small.png")
