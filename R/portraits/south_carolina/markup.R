library(tidyverse)
library(magick)
library(glue)

# Load `header` list with needed data
header <- readRDS("R/portraits/south_carolina/header.rds")
colors <- header$colors
swatchplot(colors)

text_color <- colors[5]

img <- image_read(header$outfile)


annot <- glue("This map shows population density of\n",
              "{str_to_title('south carolina')}. ",
              "Population estimates are\nbucketed ",
              "into 400 meter (about 1/4 mile) hexagons.")
cat(annot)



img |> 
  image_crop(geometry = "7250x5000+0-250", gravity = "center") |> 
  image_annotate(text = "POPULATION DENSITY", 
                 gravity = "north",
                 kerning = 30,
                 location = "+1750+800",
                 font = "El Messiri",
                 color = text_color,
                 size = 200) |> 
  image_annotate(text = annot, gravity = "southwest",
                 location = "+500+400", font = "El Messiri",
                 color = alpha(text_color, .75),
                 size = 115) |> 
  image_annotate(text = "Kontur Population Data (Released June 30, 2022)",
                 gravity = "southeast",
                 location = "+200+100", font = "El Messiri",
                 color = alpha(text_color, .5),
                 size = 80, weight = 700) |> 
  image_annotate(text = "Graphic: Spencer Schien (@MrPecners)", gravity = "southeast",
                 location = "+200+225", font = "El Messiri",
                 color = alpha(text_color, .5),
                 size = 80, weight = 700) |>
  image_write("images/south_carolina/titled_sc_pop.png")

# I'm using system() because I don't think {magick} has the functionality
# to specify stroke and weight of the annotation, so I'm using IM cli code.

system(
  glue("convert images/south_carolina/titled_sc_pop.png ",
       "-gravity North -font El-Messiri-Regular -pointsize 500 ", 
       "-stroke '{colors[5]}' -strokewidth 10 -fill '{colors[7]}' ",
       "-annotate +1750+100 'South Carolina' ",
       "-draw 'line {7250/2+(1750-1400)},750 {7250/2+(1750+1400)},750' ",
       "images/south_carolina/titled_sc_pop_done.png")
)

image_read("images/south_carolina/titled_sc_pop_done.png") |> 
  image_scale(geometry = "56%x") |> 
  image_write("tracked_graphics/titled_sc_pop_small.png")

