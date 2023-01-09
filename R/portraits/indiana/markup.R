library(tidyverse)
library(magick)
library(glue)

# Load `header` list with needed data
header <- readRDS("R/portraits/indiana/header.rds")
colors <- header$colors
swatchplot(colors)

text_color <- colors[5]

img <- image_read(header$outfile)


annot <- glue("This map shows population density\n",
              "of Indiana. Population estimates\n",
              "area bucketed into 400 meter\n",
              "(about 1/4 mile) hexagons.")
cat(annot)



img |> 
  image_crop(geometry = "7500x6500+0-250", gravity = "center") |> 
  image_annotate(text = "Indiana", 
                 gravity = "north",
                 location = "-2500+300", font = "El Messiri",
                 color = text_color,
                 size = 500, weight = 700) |> 
  image_annotate(text = "POPULATION DENSITY", 
                 kerning = 5,
                 gravity = "north",
                 location = "-2500+900", font = "El Messiri",
                 color = text_color,
                 size = 150) |>
  image_annotate(text = annot, gravity = "northwest",
                 location = "+200+2000", font = "El Messiri",
                 color = alpha(text_color, .75),
                 size = 150) |> 
  image_annotate(text = "Kontur Population Data (Released June 30, 2022)",
                 gravity = "southeast",
                 location = "+200+100", font = "El Messiri",
                 color = alpha(text_color, .5),
                 size = 80, weight = 700) |> 
  image_annotate(text = "Graphic: Spencer Schien (@MrPecners)", 
                 gravity = "southeast",
                 location = "+200+225", font = "El Messiri",
                 color = alpha(text_color, .5),
                 size = 80, weight = 700) |>
  image_write("images/indiana/titled_in_pop.png")

image_read("images/indiana/titled_in_pop.png") |> 
  image_scale(geometry = "48%x") |> 
  image_write("tracked_graphics/titled_in_pop_small.png")

