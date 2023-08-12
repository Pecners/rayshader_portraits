library(tidyverse)
library(magick)
library(glue)
library(colorspace)
library(NatParksPalettes)

# Load `header` list with needed data
header <- readRDS("R/portraits/west_coast/header.rds")
c1 <- natparks.pals("Glacier")
swatchplot(colors)

text_color <- c1[2]
t2 <- lighten(text_color, .25)
swatchplot(text_color, t2)

img <- image_read(header$outfile)


img |> 
  image_crop(geometry = "10500x14000+1000+0", gravity = "center") |> 
  image_scale("60%x") |> 
  image_annotate(text = "US Western Coastline", gravity = "northeast",
                 location = "+400+1600", font = "El Messiri",
                 color = text_color,
                 size = 450, weight = 700) |> 
  image_annotate(text = "Population Density", gravity = "northeast",
                 location = "+400+2200", font = "El Messiri",
                 color = t2,
                 size = 450) |> 
  image_annotate(text = glue("Data: Kontur Population Data | ",
                             "Graphic: Spencer Schien (@MrPecners)"), 
                 gravity = "northeast",
                 location = "+400+3000", font = "El Messiri",
                 color = alpha(text_color, .35),
                 size = 100, weight = 700) |> 
  # image_annotate(text = "Graphic: Spencer Schien (@MrPecners)", 
  #                gravity = "center",
  #                location = "-100+1900", font = "El Messiri",
  #                color = alpha(text_color, .35),
  #                size = 75, weight = 700) |> 
  image_write("images/west_coast/titled_west_coast_pop.png")

image_read("images/west_coast/titled_west_coast_pop.png") |> 
  image_scale(geometry = "55%x") |> 
  image_write("tracked_graphics/titled_west_coast_pop_small.png")

