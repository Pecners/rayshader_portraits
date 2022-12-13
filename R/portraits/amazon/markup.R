library(tidyverse)
library(svgparser)
library(magick)
library(colorspace)
library(magick)

# Load `header` list with needed data
header <- readRDS("R/portraits/amazon/header.rds")
colors <- header$colors
swatchplot(colors)

text_color <- colors[5]

# Take original graphic from `render_highquality` and
# add annotations.

img <- image_read(header$outfile)

annot <- glue("This map shows population density within 25 miles of the ",
              "Amazon River. Population estimates are bucketed ",
              "into 400 meter (1/4 mile) hexagons.") |> 
  str_wrap(50)


img |> 
  image_crop(geometry = "9800x5000+0+0", gravity = "center") |> 
  image_annotate(text = "Population Density", gravity = "north",
                 location = "+0+200", font = "El Messiri",
                 color = text_color,
                 size = 300) |> 
  image_annotate(text = "ALONG", gravity = "north",
                 location = "+0+600", font = "El Messiri",
                 color = text_color,
                 size = 200) |> 
  image_annotate(text = "The Amazon River", gravity = "north",
                 location = "+0+700", font = "El Messiri",
                 color = text_color,
                 size = 500, weight = 700) |> 
  image_annotate(text = annot, gravity = "southwest",
                 location = "+200+100", font = "El Messiri",
                 color = alpha(text_color, .75),
                 size = 200) |> 
  image_annotate(text = "Data: Kontur Population (Released 2022-06-30)", 
                 gravity = "southeast",
                 location = "+200+100", font = "El Messiri",
                 color = alpha(text_color, .5),
                 size = 125, weight = 700) |> 
  image_annotate(text = "Graphic: Spencer Schien (@MrPecners)", gravity = "southeast",
                 location = "+200+300", font = "El Messiri",
                 color = alpha(text_color, .5),
                 size = 125, weight = 700) |> 
  # image_composite(image_modulate(f_image, saturation = 100) |> 
  #                   image_scale("50%x"), 
  #                 gravity = "south", 
  #                 offset = "+0+200") |> 
  image_write("images/amazon/titled_amazon_river_pop.png")

image_read("images/amazon/titled_amazon_river_pop.png") |> 
  image_scale(geometry = "53%x") |> 
  image_write("tracked_graphics/titled_amazon_river_pop_small.png")
