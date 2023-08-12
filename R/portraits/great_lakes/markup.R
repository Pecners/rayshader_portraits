library(tidyverse)
library(magick)
library(glue)
library(colorspace)
library(NatParksPalettes)

# Load `header` list with needed data
header <- readRDS("R/portraits/great_lakes/header.rds")
c1 <- natparks.pals("Glacier")
swatchplot(colors)

text_color <- c1[2]
t2 <- lighten(text_color, .25)
swatchplot(text_color, t2)

img <- image_read(header$outfile)


img |> 
  image_crop(geometry = "8000x6000+0+500", gravity = "center") |> 
  image_annotate(text = "Great Lakes Coastline", gravity = "northeast",
                 location = "+400+500", font = "El Messiri",
                 color = text_color,
                 size = 400, weight = 700) |> 
  image_annotate(text = "Population Density", gravity = "northeast",
                 location = "+400+1000", font = "El Messiri",
                 color = t2,
                 size = 400) |> 
  image_annotate(text = glue("Data: Kontur Population Data | ",
                             "Graphic: Spencer Schien (@MrPecners)"), 
                 gravity = "northeast",
                 location = "+400+1700", font = "El Messiri",
                 color = alpha(text_color, .35),
                 size = 85, weight = 700) |> 
  # image_annotate(text = "Graphic: Spencer Schien (@MrPecners)", 
  #                gravity = "center",
  #                location = "-100+1900", font = "El Messiri",
  #                color = alpha(text_color, .35),
  #                size = 75, weight = 700) |> 
  image_write("images/great_lakes/titled_great_lakes_pop.png")

image_read("images/great_lakes/titled_great_lakes_pop.png") |> 
  image_scale(geometry = "51%x") |> 
  image_write("tracked_graphics/titled_great_lakes_pop_small.png")

