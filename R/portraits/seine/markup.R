library(tidyverse)
library(magick)
library(glue)

# Load `header` list with needed data
header <- readRDS("R/portraits/seine/header.rds")
colors <- header$colors
swatchplot(colors)

text_color <- colors[1]

img <- image_read(header$outfile)


annot <- glue("This map shows population density within ",
              "25 km of the Seine. ",
              "Population estimates are bucketed ",
              "into 400 meter hexagons.") |> 
  str_wrap(40)
cat(annot)



img |> 
  image_crop(geometry = "7500x5000+0+500", gravity = "center") |> 
  image_annotate(text = "River Seine", 
                 gravity = "north",
                 location = "-2250+2700", font = "El Messiri",
                 color = text_color,
                 size = 400, weight = 700) |> 
  image_annotate(text = "POPULATION DENSITY", 
                 gravity = "north",
                 location = "-2250+2300", font = "El Messiri",
                 color = text_color,
                 size = 200) |> 
  image_annotate(text = "ALONG THE", 
                 gravity = "north",
                 location = "-2250+2600", font = "El Messiri",
                 color = text_color,
                 size = 150) |> 
  image_annotate(text = annot, gravity = "south",
                 location = "-2250+950", font = "El Messiri",
                 color = alpha(text_color, .75),
                 size = 115) |> 
  image_annotate(text = glue("Graphic by Spencer Schien (@MrPecners) | ",
                             "Kontur Population Data (Released June 30, 2022)"),
                 gravity = "south",
                 location = "+0+100", font = "El Messiri",
                 color = alpha(text_color, .5),
                 size = 80, weight = 700) |> 

  image_write("images/seine/titled_seine_pop.png")

image_read("images/seine/titled_seine_pop.png") |> 
  image_scale(geometry = "57%x") |> 
  image_write("tracked_graphics/titled_seine_pop_small.png")

