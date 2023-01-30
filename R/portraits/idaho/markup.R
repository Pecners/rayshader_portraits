library(tidyverse)
library(magick)
library(glue)
library(colorspace)

# Load `header` list with needed data
header <- readRDS("R/portraits/idaho/header.rds")
colors <- header$colors
swatchplot(colors)

text_color <- colors[4]

img <- image_read(header$outfile)


annot <- glue("This map shows population density of ",
              "{str_to_title('idaho')}. ",
              "Population estimates are bucketed ",
              "into 400 meter (about 1/4 mile) hexagons.") |> 
  str_wrap(45)
cat(annot)


img |> 
  image_crop(geometry = "7000x6000+0+300", gravity = "center") |> 
  image_annotate(text = "POPULATION DENSITY", 
                 gravity = "north",
                 location = "+1300+1250", 
                 kerning = 10,
                 font = "El Messiri",
                 color = text_color,
                 size = 200) |> 
  image_annotate(text = annot, gravity = "north",
                 location = "+1300+1600", font = "El Messiri",
                 color = alpha(text_color, .75),
                 size = 115) |> 
  image_annotate(text = "Kontur Population Data (Released June 30, 2022)",
                 gravity = "southeast",
                 location = "+200+100", font = "El Messiri",
                 color = alpha(text_color, .5),
                 size = 80, weight = 700) |> 
  image_annotate(text = "Graphic: Spencer Schien (@MrPecners)", 
                 gravity = "southeast",
                 location = "+200+225", font = "El Messiri",
                 color = alpha(text_color, .5),
                 size = 80, weight = 700) |>
  image_write("images/idaho/titled_id_pop.png")

system(
  glue("convert images/idaho/titled_id_pop.png ",
       "-gravity north -font El-Messiri-Regular -pointsize 600 ", 
       "-stroke '{colors[4]}' -strokewidth 10 -fill '{colors[6]}' ",
       "-kerning 200 -annotate +1300+500 'Idaho' ", 
       "images/idaho/titled_id_pop_done.png")
)

image_read("images/idaho/titled_id_pop_done.png") |> 
  image_scale(geometry = "55%x") |> 
  image_write("tracked_graphics/titled_id_pop_small.png")

