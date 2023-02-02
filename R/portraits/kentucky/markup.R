library(tidyverse)
library(magick)
library(glue)

# Load `header` list with needed data
header <- readRDS("R/portraits/kentucky/header.rds")
colors <- header$colors
swatchplot(colors)

text_color <- colors[4]

img <- image_read(header$outfile)


annot <- glue("This map shows population density of ",
              "{str_to_title('kentucky')}. ",
              "Population estimates are bucketed ",
              "into 400 meter (about 1/4 mile) hexagons.") |> 
  str_wrap(45)
cat(annot)



img |> 
  image_crop(geometry = "10000x5000+0-500", gravity = "center") |> 
  # image_annotate(text = glue("{str_to_title('kentucky')} Population Density"), 
  #                gravity = "northwest",
  #                location = "+200+100", font = "El Messiri",
  #                color = text_color,
  #                size = 225, weight = 700) |> 
  # image_annotate(text = annot, gravity = "west",
  #                location = "+200+500", font = "El Messiri",
  #                color = alpha(text_color, .75),
  #                size = 115) |> 
  image_annotate(text = glue("Graphic: Spencer Schien (@MrPecners) | ",
                             "Kontur Population Data (Released June 30, 2022)"),
                 gravity = "south",
                 location = "+200+100", 
                 font = "El Messiri",
                 color = alpha(text_color, .5),
                 size = 80, weight = 700,
                 kerning = 20) |> 
  image_write("images/kentucky/titled_ky_pop.png")

system(
  glue("convert -size 10000x5000 xc:none ",
       "-gravity north -font El-Messiri-Bold ",
       "-pointsize 400 -kerning 100 -stroke '{colors[4]}' -fill '{colors[4]}' ", 
       "-annotate +20+485 'KENTUCKY POPULATION DENSITY' ",
       "-background none -blur 50x15 +repage ",
       "-stroke '{colors[4]}' -strokewidth 5 -fill '{colors[6]}' ",
       "-kerning 100 -annotate +0+500 'KENTUCKY POPULATION DENSITY' ", 
       "images/kentucky/titled_ky_pop.png +swap -gravity north ",
       "-composite images/kentucky/titled_ky_pop_done.png")
)

image_read("images/kentucky/titled_ky_pop_done.png") |> 
  image_scale(geometry = "49%x") |> 
  image_write("tracked_graphics/titled_ky_pop_small.png")

