library(tidyverse)
library(magick)
library(glue)
library(colorspace)
library(NatParksPalettes)

# Load `header` list with needed data
header <- readRDS("R/portraits/east_coast/header.rds")
c1 <- natparks.pals("Glacier")
swatchplot(colors)

text_color <- c1[2]
t2 <- lighten(text_color, .25)
swatchplot(text_color, t2)

img <- image_read(header$outfile)



img |> 
  image_crop(geometry = "6500x7000+300+300", gravity = "center") |> 
  image_annotate(text = "US Eastern Coastline", gravity = "northwest",
                 location = "+400+500", font = "El Messiri",
                 color = text_color,
                 size = 400, weight = 700) |> 
  image_annotate(text = "Population Density", gravity = "northwest",
                 location = "+400+1000", font = "El Messiri",
                 color = t2,
                 size = 400) |> 
  image_annotate(text = glue("Data: Kontur Population Data | ",
                             "Graphic: Spencer Schien (@MrPecners)"), 
                 gravity = "northwest",
                 location = "+400+1700", font = "El Messiri",
                 color = alpha(text_color, .35),
                 size = 85, weight = 700) |> 
  # image_annotate(text = "Graphic: Spencer Schien (@MrPecners)", gravity = "southeast",
  #                location = "+200+100", font = "El Messiri",
  #                color = alpha(text_color, .5),
  #                size = 100, weight = 700) |> 
  image_write("images/east_coast/titled_east_coast.png")

image_read("images/east_coast/titled_east_coast.png") |> 
  image_scale(geometry = "54%x") |> 
  image_write("tracked_graphics/titled_east_coast_pop_small.png")

