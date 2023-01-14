library(tidyverse)
library(magick)
library(glue)

# Load `header` list with needed data
header <- readRDS("R/portraits/oregon/header.rds")
colors <- header$colors
swatchplot(colors)

text_color <- colors[5]

img <- image_read(header$outfile)


annot <- glue("This map shows population\ndensity of ",
              "{str_to_title('oregon')}. ",
              "Population estimates\nare bucketed ",
              "into 400 meter (about 1/4 mile) hexagons.")
cat(annot)



img |> 
  image_crop(geometry = "8000x5500+0+300", gravity = "center") |> 
  # image_annotate(text = "Oregon",
  #                gravity = "north", 
  #                location = "-2000+200", font = "El Messiri",
  #                color = text_color, decoration = "underline",
  #                size = 500, weight = 700) |> 
  image_annotate(text = "POPULATION DENSITY", 
                 gravity = "north",
                 kerning = 15,
                 location = "-2000+900",
                 font = "El Messiri",
                 color = text_color,
                 size = 150) |> 
  image_annotate(text = annot, gravity = "southeast",
                 location = "+200+800", font = "El Messiri",
                 color = alpha(text_color, .75),
                 size = 115) |> 
  image_annotate(text = glue("Graphic: Spencer Schien (@MrPecners) | ",
                             "Kontur Population Data (Released June 30, 2022)"),
                 gravity = "southeast",
                 location = "+200+100", font = "El Messiri",
                 color = alpha(text_color, .5),
                 size = 80, weight = 700) |> 
  # image_annotate(text = "Graphic: Spencer Schien (@MrPecners)", gravity = "southwest",
  #                location = "+200+225", font = "El Messiri",
  #                color = alpha(text_color, .5),
  #                size = 80, weight = 700) |>
  image_write("images/oregon/titled_or_pop.png")

# I'm using system because I don't think {magick} has the functionality
# to specify stroke and weight of the annotation, so I'm using IM cli code.

system(
  glue("convert images/oregon/titled_or_pop.png ",
       "-gravity North -font El-Messiri-Regular -pointsize 600 ", 
       "-stroke '{colors[5]}' -strokewidth 10 -fill '{colors[7]}' -annotate -2000+100 ", 
       "'Oregon' images/oregon/titled_or_pop_done.png")
)

image_read("images/oregon/titled_or_pop_done.png") |> 
  image_scale(geometry = "53%x") |> 
  image_write("tracked_graphics/titled_or_pop_small.png")

