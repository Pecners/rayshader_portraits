library(tidyverse)
library(magick)
library(glue)

# Load `header` list with needed data
header <- readRDS("R/portraits/illinois/header.rds")
colors <- header$colors
swatchplot(colors)

text_color <- colors[5]

img <- image_read(header$outfile)


annot <- glue("This map shows population density of Illinois. ",
              "Population estimates are bucketed ",
              "into 400 meter (about 1/4 mile) hexagons.") |> 
  str_wrap(43)
cat(annot)



img |> 
  image_crop(geometry = "6000x6500+0+0", gravity = "center") |> 
  image_annotate(text = "Illinois Population Density", gravity = "northwest",
                 location = "+200+100", font = "El Messiri",
                 color = text_color,
                 size = 225, weight = 700) |> 
  image_annotate(text = annot, gravity = "southwest",
                 location = "+200+800", font = "El Messiri",
                 color = alpha(text_color, .75),
                 size = 115) |> 
  image_annotate(text = "Kontur Population Data (Released June 30, 2022)",
                 gravity = "southwest",
                 location = "+200+100", font = "El Messiri",
                 color = alpha(text_color, .5),
                 size = 80, weight = 700) |> 
  image_annotate(text = "Graphic: Spencer Schien (@MrPecners)", gravity = "southwest",
                 location = "+200+225", font = "El Messiri",
                 color = alpha(text_color, .5),
                 size = 80, weight = 700) |>
  image_write("images/illinois/titled_il_pop.png")

image_read("images/illinois/titled_il_pop.png") |> 
  image_scale(geometry = "50%x") |> 
  image_write("tracked_graphics/titled_il_pop_small.png")

