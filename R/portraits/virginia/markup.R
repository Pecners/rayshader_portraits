library(tidyverse)
library(magick)

# Load `header` list with needed data
header <- readRDS("R/portraits/virginia/header.rds")
colors <- header$colors
swatchplot(colors)

text_color <- darken(colors[5], .5)

img <- image_read(header$outfile)


annot <- glue("This map shows population density of Virginia. ",
              "Population estimates are bucketed ",
              "into 400 meter (about 1/4 mile) hexagons.") |> 
  str_wrap(32)



img |> 
  image_crop(geometry = "7750x4500+500+500", gravity = "center") |> 
  image_annotate(text = "Virginia Population Density", gravity = "northwest",
                 location = "+200+100", font = "El Messiri",
                 color = text_color,
                 size = 250, weight = 700) |> 
  image_annotate(text = annot, gravity = "west",
                 location = "+200-500", font = "El Messiri",
                 color = alpha(text_color, .75),
                 size = 125) |> 
  image_annotate(text = "Data: Kontur Population Data (Released June 30, 2022)", gravity = "southeast",
                 location = "+200+100", font = "El Messiri",
                 color = alpha(text_color, .5),
                 size = 80, weight = 700) |> 
  image_annotate(text = "Graphic: Spencer Schien (@MrPecners)", gravity = "southeast",
                 location = "+200+225", font = "El Messiri",
                 color = alpha(text_color, .5),
                 size = 80, weight = 700) |> 
  image_write("images/virginia/titled_va_pop.png")

