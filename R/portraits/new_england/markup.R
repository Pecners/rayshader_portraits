library(tidyverse)
library(magick)
library(glue)
library(colorspace)

# Load `header` list with needed data
header <- readRDS("R/portraits/new_england/header.rds")
colors <- header$colors
swatchplot(colors)

text_color <- colors[4]

img <- image_read(header$outfile)


annot <- glue("This map shows population density of ",
              "New England. ",
              "Population estimates are bucketed ",
              "into 400 meter (about 1/4 mile) hexagons.") |> 
  str_wrap(45)
cat(annot)

inset <- image_read("images/new_england/demuth_inset.png")

img |> 
  image_crop(geometry = "7500x6000+0+0", gravity = "south") |> 
  image_annotate(text = "New England", 
                 gravity = "northeast",
                 location = "+200+100", font = "El Messiri",
                 color = text_color,
                 size = 275, weight = 700) |> 
  image_annotate(text = "POPULATION DENSITY", 
                 gravity = "northeast",
                 location = "+200+500", font = "El Messiri",
                 color = text_color,
                 size = 150) |> 
  image_annotate(text = annot, gravity = "northeast",
                 location = "+200+1500", font = "El Messiri",
                 color = alpha(text_color, .75),
                 size = 115) |> 
  image_annotate(text = glue("Graphic: Spencer Schien (@MrPecners) | ",
                             "Kontur Population Data (Released June 30, 2022)"),
                 gravity = "south",
                 location = "+0+50", font = "El Messiri",
                 color = alpha(text_color, .5),
                 size = 80, weight = 700) |> 
  image_annotate(text = "73°W", 
                 gravity = "southeast",
                 location = "+230+630", 
                 degrees = -70,
                 font = "El Messiri",
                 color = alpha(text_color, .5),
                 size = 80) |> 
  image_annotate(text = "41°N", 
                 gravity = "southeast",
                 location = "+1700+225", 
                 degrees = -65,
                 font = "El Messiri",
                 color = alpha(text_color, .5),
                 size = 80) |> 
  image_annotate(text = "44°N", 
                 gravity = "south",
                 location = "-1125+1100", 
                 degrees = -65,
                 font = "El Messiri",
                 color = alpha(text_color, .5),
                 size = 80) |> 
  image_composite(image_scale(inset, geometry = "65%x"),
                  gravity = "southwest",
                  offset = "+100+100") |> 
  image_write("images/new_england/titled_new_england_pop.png")

image_read("images/new_england/titled_new_england_pop.png") |> 
  image_scale(geometry = "50%x") |> 
  image_write("tracked_graphics/titled_new_england_pop_small.png")

