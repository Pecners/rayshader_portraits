library(tidyverse)
library(magick)
library(glue)

# Load `header` list with needed data
header <- readRDS("R/portraits/seine/header.rds")
colors <- header$colors
swatchplot(colors)

text_color <- colors[1]

img <- image_read(header$outfile)


annot <- glue("Cette carte montre la densité de population ",
              "à moins de 25 km de la Seine. Les estimations ",
              "de la population sont regroupées en hexagone de 400 mètres.") |> 
  str_wrap(40)
cat(annot)



img |> 
  image_crop(geometry = "7500x5000+0+500", gravity = "center") |> 
  image_annotate(text = "La Seine", 
                 gravity = "north",
                 location = "-2250+2750", font = "El Messiri",
                 color = text_color,
                 size = 400, weight = 700) |> 
  image_annotate(text = "DENSITÉ DE POPULATION", 
                 gravity = "north",
                 location = "-2250+2300", font = "El Messiri",
                 color = text_color,
                 size = 200) |> 
  image_annotate(text = "LE LONG DE", 
                 gravity = "north",
                 location = "-2250+2600", font = "El Messiri",
                 color = text_color,
                 size = 150) |> 
  image_annotate(text = annot, gravity = "south",
                 location = "-2250+850", font = "El Messiri",
                 color = alpha(text_color, .75),
                 size = 115) |> 
  image_annotate(text = glue("Réalisation : Spencer Schien (@MrPecners) | ",
                             "Données: Kontur Population Data (30 juin 2022)"),
                 gravity = "south",
                 location = "+0+100", font = "El Messiri",
                 color = alpha(text_color, .5),
                 size = 80, weight = 700) |> 
  image_write("images/seine/titled_seine_pop_fr.png")

image_read("images/seine/titled_seine_pop_fr.png") |> 
  image_scale(geometry = "57%x") |> 
  image_write("tracked_graphics/titled_seine_pop_fr_small.png")

