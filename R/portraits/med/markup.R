library(tidyverse)
library(svgparser)
library(magick)
library(colorspace)
library(magick)

# Load `header` list with needed data
header <- readRDS("R/portraits/med/header.rds")
colors <- header$colors
swatchplot(colors)
text_color <- colors[5]

# Take original graphic from `render_highquality` and
# add annotations.

img <- image_read(header$outfile)

annot <- glue("This map shows population density within 25 km of the ",
              "Mediterranean Sea. Population estimates are bucketed ",
              "into 400 meter hexagons.") |> 
  str_wrap(47)

cat(annot)


img |> 
  image_crop(geometry = "9500x5000+0+100", gravity = "center") |> 
  image_annotate(text = "POPULATION DENSITY ALONG THE", gravity = "north",
                 location = "+2500+400", font = "El Messiri",
                 color = text_color,
                 size = 150) |> 
  image_annotate(text = "Mediterranean Coast", gravity = "north",
                 location = "+2500+600", font = "El Messiri",
                 color = text_color,
                 size = 350, weight = 700) |> 
  image_annotate(text = annot, gravity = "southwest",
                 location = "+200+200", font = "El Messiri",
                 color = alpha(text_color, .75),
                 size = 125) |> 
  image_annotate(text = "Kontur Population Data (June 30, 2022 Release)", gravity = "southeast",
                 location = "+200+100", font = "El Messiri",
                 color = alpha(text_color, .5),
                 size = 75, weight = 700) |> 
  image_annotate(text = "Graphic by Spencer Schien (@MrPecners)", gravity = "southeast",
                 location = "+200+200", font = "El Messiri",
                 color = alpha(text_color, .5),
                 size = 75, weight = 700) |> 
  # image_composite(image_modulate(f_image, saturation = 100) |> 
  #                   image_scale("50%x"), 
  #                 gravity = "south", 
  #                 offset = "+0+200") |> 
  image_write("images/med/titled_med_pop.png")

image_read("images/med/titled_med_pop.png") |> 
  image_scale(geometry = "48%x") |> 
  image_write("tracked_graphics/titled_med_pop_small.png")
