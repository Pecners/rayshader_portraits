library(tidyverse)
library(magick)
library(glue)

# Load `header` list with needed data
header <- readRDS("R/portraits/arizona/header.rds")
colors <- header$colors
swatchplot(colors)

text_color <- colors[1]

img <- image_read(header$outfile)


annot <- glue("This map shows population density of ",
              "{str_to_title('arizona')}. ",
              "Population estimates are bucketed ",
              "into 400 meter (about 1/4 mile) hexagons.") |> 
  str_wrap(20)
cat(annot)



img |> 
  image_crop(geometry = "8000x6600+0+300", gravity = "north") |> 
  image_annotate(text = "Arizona", 
                 gravity = "north",
                 location = "+3000+300", font = "El Messiri",
                 color = text_color,
                 size = 400, weight = 700) |> 
  image_annotate(text = "POPULATION DENSITY",
                 gravity = "north",
                 location = "+3000+900", font = "El Messiri",
                 color = text_color,
                 size = 150) |>
  image_annotate(text = annot, gravity = "west",
                 location = "+200+2000", font = "El Messiri",
                 color = alpha(text_color, .75),
                 size = 115) |> 
  image_annotate(text = glue("Graphic by Spencer Schien (@MrPecners) | ",
                             "Kontur Population Data (Released June 30, 2022)"),
                 gravity = "south",
                 location = "+200+50", font = "El Messiri",
                 color = alpha(text_color, .5),
                 size = 80, weight = 700) |> 
  image_write("images/arizona/titled_az_pop.png")

image_read("images/arizona/titled_az_pop.png") |> 
  image_scale(geometry = "47%x") |> 
  image_write("tracked_graphics/titled_az_pop_small.png")

