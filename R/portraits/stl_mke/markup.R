library(tidyverse)
library(magick)
library(glue)

# Load `header` list with needed data
header <- readRDS("R/portraits/stl_mke/header.rds")
colors <- header$colors
swatchplot(colors)

text_color <- colors[1]

img <- image_read(header$outfile)


annot <- glue("This graphic shows a side-by-side comparison ",
              "of population density in St. Louis and Milwaukee. ",
              "Population estimates are bucketed ",
              "into 400 meter (about 1/4 mile) hexagons.") |> 
  str_wrap(60)
cat(annot)



img |> 
  image_crop(geometry = "7500x6500+0-250", gravity = "center") |> 
  image_annotate(text = glue("Comparative Population Density"), 
                 gravity = "northwest",
                 location = "+200+100", font = "El Messiri",
                 color = text_color,
                 size = 225, weight = 700) |> 
  image_annotate(text = annot, gravity = "northwest",
                 location = "+200+500", font = "El Messiri",
                 color = alpha(text_color, .75),
                 size = 115) |> 
  image_annotate("Milwaukee, Wisconsin",
                 gravity = "south",
                 location = "+1200+800",
                 font = "El Messiri",
                 color = text_color,
                 size = 125,
                 weight = 700) |> 
  image_annotate("St. Louis, Missouri",
                 gravity = "south",
                 location = "-2500+1000",
                 font = "El Messiri",
                 color = text_color,
                 size = 125,
                 weight = 700) |> 
  image_annotate(text = glue("Graphic: Spencer Schien (@MrPecners) | ",
                             "Kontur Population Data (Released June 30, 2022)"),
                 gravity = "south",
                 location = "+0+100", font = "El Messiri",
                 color = alpha(text_color, .5),
                 size = 80, weight = 700) |> 
  image_write("images/stl_mke/titled_stl_mke_pop.png")

image_read("images/stl_mke/titled_stl_mke_pop.png") |> 
  image_scale(geometry = "49%x") |> 
  image_write("tracked_graphics/titled_stl_mke_pop_small.png")

