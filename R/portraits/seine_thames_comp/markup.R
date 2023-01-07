library(tidyverse)
library(magick)
library(glue)
library(colorspace)

# Load `header` list with needed data
header <- readRDS("R/portraits/seine_thames_comp/header.rds")
colors <- header$colors
swatchplot(colors)

text_color <- colors[4]

img <- image_read(header$outfile)


annot <- glue("This map shows population density within 25 km ",
              "of the Seine (above) and Thames (below) rivers. ",
              "Population estimates are bucketed ",
              "into 400 meter (about 1/4 mile) hexagons.") |> 
  str_wrap(45)
cat(annot)



img |> 
  image_crop(geometry = "7500x5500+0+500", gravity = "center") |> 
  image_annotate(text = "A Tale of Two Rivers", 
                 gravity = "northeast",
                 location = "+200+100", font = "El Messiri",
                 color = text_color,
                 size = 300, weight = 700) |> 
  image_annotate(text = annot, gravity = "northeast",
                 location = "+200+750", font = "El Messiri",
                 color = alpha(text_color, .75),
                 size = 125) |> 
  image_annotate(text = glue("Graphic by Spencer Schien (@MrPecners) | ",
                             "Kontur Population Data (Released June 30, 2022)"),
                 gravity = "southwest",
                 location = "+200+100", font = "El Messiri",
                 color = alpha(text_color, .5),
                 size = 80, weight = 700) |> 
  image_write("images/seine_thames_comp/titled_seine_thames_pop.png")

image_read("images/seine_thames_comp/titled_seine_thames_pop.png") |> 
  image_scale(geometry = "55%x") |> 
  image_write("tracked_graphics/titled_seine_thames_pop_small.png")

