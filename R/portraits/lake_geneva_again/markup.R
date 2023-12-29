library(tidyverse)
library(magick)
library(glue)
library(colorspace)

# Load `header` list with needed data
header <- readRDS("R/portraits/lake_geneva/header.rds")
colors <- header$colors
swatchplot(colors)

text_color <- colors[5]

img <- image_read(header$outfile)


annot <- glue("This map shows population density of ",
              "{str_to_title('lake_geneva_again')}. ",
              "Population estimates are bucketed ",
              "into 400 meter (about 1/4 mile) hexagons.") |> 
  str_wrap(45)
cat(annot)



img |> 
  image_crop(geometry = "8000x6000+0+0", gravity = "center") |> 
  # image_annotate(text = "LAKE GENEVA", 
  #                gravity = "north",
  #                location = "+0+200", font = "Poller One",
  #                color = colors[5],
  #                size = 500, weight = 700, kernin = 50) |> 
  # image_annotate(text = "Population Density", 
  #                gravity = "north",
  #                location = "+0+800", font = "El Messiri",
  #                color = colors[10],
  #                size = 400, kerning = 50) |> 
  # image_annotate(text = glue("Graphic by  Spencer Schien (@MrPecners) | ",
  #                            "Kontur Population Data (Released June 30, 2022)"),
  #                gravity = "north",
  #                location = "+0+1250", font = "El Messiri",
  #                color = alpha(colors[10], .5),
  #                size = 70, weight = 700, kerning = 10) |> 
  image_write("images/lake_geneva_again/titled_lg_pop.png")

image_read("images/lake_geneva_again/titled_lg_pop.png") |> 
  image_scale(geometry = "60%x") |> 
  image_write("tracked_graphics/titled_lg_pop_small.png")

