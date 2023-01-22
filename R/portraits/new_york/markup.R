library(tidyverse)
library(magick)
library(glue)

# Load `header` list with needed data
header <- readRDS("R/portraits/new_york/header.rds")
colors <- header$colors
swatchplot(colors)

text_color <- colors[5]

img <- image_read(header$outfile)


annot <- glue("This map shows population density of New York.\n",
              "Population estimates are bucketed ",
              "into\n400 meter (about 1/4 mile) hexagons.")
cat(annot)



img |> 
  image_crop(geometry = "7750x5000+500+500", gravity = "center") |> 
  image_annotate(text = "POPULATION DENSITY", 
                 gravity = "north",
                 kerning = 30,
                 location = "-2500+800",
                 font = "El Messiri",
                 color = text_color,
                 size = 150) |> 
  image_annotate(text = annot, gravity = "south",
                 location = "+600+400", font = "El Messiri",
                 color = alpha(text_color, .75),
                 size = 115) |> 
  image_annotate(text = glue("Graphic: Spencer Schien (@MrPecners) | ",
                             "Kontur Population Data (Released June 30, 2022)"),
                 gravity = "south",
                 location = "+600+100", font = "El Messiri",
                 color = alpha(text_color, .5),
                 size = 80, weight = 700) |> 
  image_write("images/new_york/titled_ny_pop.png")

# I'm using system() because I don't think {magick} has the functionality
# to specify stroke and weight of the annotation, so I'm using IM cli code.

system(
  glue("convert images/new_york/titled_ny_pop.png ",
       "-gravity North -font El-Messiri-Bold -pointsize 500 ", 
       "-stroke '{colors[5]}' -strokewidth 15 -fill '{colors[9]}' ",
       "-annotate -2500+100 'New York' ",
       "-draw 'line {7750/2-(2500-1050)},750 {7750/2-(2500+1050)},750' ",
       "images/new_york/titled_ny_pop_done.png")
)

image_read("images/new_york/titled_ny_pop_done.png") |> 
  image_scale(geometry = "54%x") |> 
  image_write("tracked_graphics/titled_ny_pop_small.png")

