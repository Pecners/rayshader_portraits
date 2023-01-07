library(tidyverse)
library(magick)
library(glue)

# Load `header` list with needed data
header <- readRDS("R/portraits/thames/header.rds")
colors <- header$colors
swatchplot(colors)

text_color <- colors[1]

img <- image_read(header$outfile)


annot <- glue("This map shows population density\n",
              "within 25 km of the Thames. ",
              "Population estimates\nare bucketed ",
              "into 400 meter (about 1/4 mile) hexagons.") 
cat(annot)



img |> 
  image_crop(geometry = "7750x4250+0+0", gravity = "center") |> 
  image_annotate(text = "River Thames", 
                 gravity = "north",
                 location = "+2000+750", font = "El Messiri",
                 color = text_color,
                 size = 400, weight = 700) |> 
  image_annotate(text = "POPULATION DENSITY", 
                 gravity = "north",
                 location = "+2000+300", font = "El Messiri",
                 color = text_color,
                 size = 200) |> 
  image_annotate(text = "ALONG THE", 
                 gravity = "north",
                 location = "+2000+600", font = "El Messiri",
                 color = text_color,
                 size = 150) |> 
  image_annotate(text = annot, gravity = "southwest",
                 location = "+200+300", font = "El Messiri",
                 color = alpha(text_color, .75),
                 size = 115) |> 
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
  image_write("images/thames/titled_thames_pop.png")

image_read("images/thames/titled_thames_pop.png") |> 
  image_scale(geometry = "60%x") |> 
  image_write("tracked_graphics/titled_thames_pop_small.png")

