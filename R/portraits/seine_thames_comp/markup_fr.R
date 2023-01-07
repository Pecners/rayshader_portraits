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


annot <- glue("Cette carte montre la densité de population ",
              "à moins de 25 km de la Seine (au dessus) et la Tamise (sous). ",
              "Les estimations ",
              "de population sont regroupées en hexagone de 400 mètres.") |> 
  str_wrap(40)
cat(annot)



img |> 
  image_crop(geometry = "7500x5500+0+500", gravity = "center") |> 
  image_annotate(text = "Le Conte de deux fleuves", 
                 gravity = "northeast",
                 location = "+200+100", font = "El Messiri",
                 color = text_color,
                 size = 300, weight = 700) |> 
  image_annotate(text = annot, gravity = "northeast",
                 location = "+200+750", font = "El Messiri",
                 color = alpha(text_color, .75),
                 size = 125) |> 
  image_annotate(text = glue("Réalisation : Spencer Schien (@MrPecners) | ",
                             "Données : Kontur Population Data (30 juin 2022)"),
                 gravity = "southwest",
                 location = "+200+100", font = "El Messiri",
                 color = alpha(text_color, .5),
                 size = 80, weight = 700) |> 
  image_write("images/seine_thames_comp/titled_seine_thames_pop_fr.png")

image_read("images/seine_thames_comp/titled_seine_thames_pop_fr.png") |> 
  image_scale(geometry = "55%x") |> 
  image_write("tracked_graphics/titled_seine_thames_pop_small_fr.png")

