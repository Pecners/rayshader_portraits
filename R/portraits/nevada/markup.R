library(tidyverse)
library(magick)
library(glue)
library(colorspace)

# Load `header` list with needed data
header <- readRDS("R/portraits/nevada/header.rds")
colors <- header$colors
swatchplot(colors)

text_color <- colors[1]

img <- image_read(header$outfile)


s <- darken("#9a9397", .1)
  
shadow <- "#9a9397"
inset <- image_read("images/nevada/tam_inset.png")
  

img |> 
  image_crop(geometry = "7500x8500+400+0", gravity = "center") |> 
  image_annotate(text = "NEVADA", 
                 gravity = "north",
                 location = "+1500+300", font = "Marhey",
                 color = text_color, kerning = 300,
                 size = 400, weight = 700) |> 
  image_annotate(text = "POPULATION DENSITY",
                 gravity = "north",
                 location = "+1500+900", font = "Marhey",
                 color = text_color, kerning = 75,
                 size = 175) |>
  image_annotate(text = glue("Graphic by Spencer Schien (@MrPecners) | ",
                             "Kontur Population Data (Released June 30, 2022)"),
                 gravity = "south",
                 location = "+0+100", font = "Marhey",
                 color = alpha(text_color, .5),
                 kerning = 20,
                 size = 70) |> 
  image_composite(image_scale(inset, geometry = "75%x"),
                  gravity = "southwest",
                  offset = "+500+750") |> 
  image_write("images/nevada/titled_nv_pop.png")




image_read("images/nevada/titled_nv_pop.png") |> 
  image_scale(geometry = "45%x") |> 
  image_write("tracked_graphics/titled_nv_pop_small.png")
