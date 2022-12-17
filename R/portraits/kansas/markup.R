library(tidyverse)
library(magick)

# Load `header` list with needed data
header <- readRDS("R/portraits/kansas/header.rds")
colors <- header$colors
swatchplot(colors)

text_color <- colors[9]

img <- image_read(header$outfile)


annot <- glue("This map shows population density of Kansas. ",
              "Population estimates are bucketed ",
              "into 400 meter (about 1/4 mile) hexagons.") |> 
  str_wrap(43)
cat(annot)



img |> 
  image_crop(geometry = "8000x4500+0+0", gravity = "center") |> 
  image_annotate(text = "Kansas Population Density", gravity = "northwest",
                 location = "+200+100", font = "El Messiri",
                 color = text_color,
                 size = 250, weight = 700) |> 
  image_annotate(text = annot, gravity = "northwest",
                 location = "+200+600", font = "El Messiri",
                 color = alpha(text_color, .75),
                 size = 115) |> 
  image_annotate(text = "Kontur Population Data (Released June 30, 2022)", gravity = "southeast",
                 location = "+200+100", font = "El Messiri",
                 color = alpha(text_color, .5),
                 size = 80, weight = 700) |> 
  image_annotate(text = "Graphic: Spencer Schien (@MrPecners)", gravity = "southeast",
                 location = "+200+225", font = "El Messiri",
                 color = alpha(text_color, .5),
                 size = 80, weight = 700) |> 
  image_write("images/kansas/titled_ks_pop.png")

