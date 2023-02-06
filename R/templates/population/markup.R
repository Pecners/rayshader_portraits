library(tidyverse)
library(magick)
library(glue)
library(colorspace)

# Load `header` list with needed data
header <- readRDS("R/portraits/CONFIG_MAP/header.rds")
colors <- header$colors
swatchplot(colors)

text_color <- colors[1]

img <- image_read(header$outfile)


annot <- glue("This map shows population density of ",
              "{str_to_title('CONFIG_MAP')}. ",
              "Population estimates are bucketed ",
              "into 400 meter (about 1/4 mile) hexagons.") |> 
  str_wrap(45)
cat(annot)



img |> 
  image_crop(geometry = "7250x4000+400+0", gravity = "center") |> 
  image_annotate(text = glue("{str_to_title('CONFIG_MAP')} Population Density"), 
                 gravity = "northwest",
                 location = "+200+100", font = "El Messiri",
                 color = text_color,
                 size = 225, weight = 700) |> 
  image_annotate(text = annot, gravity = "northeast",
                 location = "+200+500", font = "El Messiri",
                 color = alpha(text_color, .75),
                 size = 115) |> 
  image_annotate(text = "Kontur Population Data (Released June 30, 2022)",
                 gravity = "southwest",
                 location = "+200+100", font = "El Messiri",
                 color = alpha(text_color, .5),
                 size = 80, weight = 700) |> 
  image_annotate(text = "Graphic: Spencer Schien (@MrPecners)", gravity = "southwest",
                 location = "+200+225", font = "El Messiri",
                 color = alpha(text_color, .5),
                 size = 80, weight = 700) |>
  image_write("images/CONFIG_MAP/titled_STATE_pop.png")

image_read("images/CONFIG_MAP/titled_STATE_pop.png") |> 
  image_scale(geometry = "60%x") |> 
  image_write("tracked_graphics/titled_STATE_pop_small.png")

