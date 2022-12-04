library(tidyverse)
library(svgparser)
library(magick)
library(colorspace)
library(magick)

# Load `header` list with needed data
header <- readRDS("R/portraits/nile/header.rds")
colors <- header$colors
swatchplot(colors)

# Take original graphic from `render_highquality` and
# add annotations.

# compass
# Compass rose SVG from here: https://freesvg.org/compass-rose-vector-sketch
# I edited the SVG file to change fill from black to the palette blue
t_rose <- tempfile()
text_color <- colors[5]
grid_color <- alpha(colors[4], .75)


read_lines("R/portraits/michigan_pop/CompassRose.svg") |> 
  gsub(x = _, pattern = "#326812", text_color) |> 
  gsub(x = _, pattern = "#99ce64", colors[10]) |> 
  write_lines(file = t_rose)

rose <- read_svg(t_rose)

tmp <- tempfile()
png(tmp, bg = "transparent", width = 1000, height = 1000)
grid::grid.newpage()
grid::grid.draw(rose)
dev.off()

svg_tmp <- image_read(tmp)
svg_tmp

f_image <- image_blank(width = image_info(svg_tmp)$width * 1.5, 
                       height = image_info(svg_tmp)$height * 1.5, color = "none") |> 
  image_composite(svg_tmp, operator = "plus", gravity = "center") |> 
  image_annotate(gravity = "north", text = "N", font = "El Messiri", 
                 size = 200, weight = 700,
                 color = text_color) |> 
  image_background(color = "none") |> 
  image_scale(geometry = "100%x77%")

f_image

img <- image_read(header$outfile)

annot <- glue("This map shows population density within 25 miles of the ",
              "Nile. Population estimates are bucketed ",
              "into 400 meter hexagons.") |> 
  str_wrap(20)


img |> 
  image_crop(geometry = "7200x8500-500+0", gravity = "center") |> 
  image_annotate(text = "Population Density", gravity = "north",
                 location = "+1800+500", font = "El Messiri",
                 color = text_color,
                 size = 300) |> 
  image_annotate(text = "ALONG", gravity = "north",
                 location = "+1800+1000", font = "El Messiri",
                 color = text_color,
                 size = 200) |> 
  image_annotate(text = "The Nile", gravity = "north",
                 location = "+1800+1300", font = "El Messiri",
                 color = text_color,
                 size = 500, weight = 700) |> 
  image_annotate(text = annot, gravity = "west",
                 location = "+500+1000", font = "El Messiri",
                 color = alpha(text_color, .75),
                 size = 200) |> 
  image_annotate(text = "Data: Kontur Population Data", gravity = "southeast",
                 location = "+200+300", font = "El Messiri",
                 color = alpha(text_color, .5),
                 size = 125, weight = 700) |> 
  image_annotate(text = "Graphic: Spencer Schien (@MrPecners)", gravity = "southeast",
                 location = "+200+100", font = "El Messiri",
                 color = alpha(text_color, .5),
                 size = 125, weight = 700) |> 
  # image_composite(image_modulate(f_image, saturation = 100) |> 
  #                   image_scale("50%x"), 
  #                 gravity = "south", 
  #                 offset = "+0+200") |> 
  image_write("images/nile/titled_nile_river_pop.png")

image_read("images/nile/titled_nile_river_pop.png") |> 
  image_scale(geometry = "45%x") |> 
  image_write("tracked_graphics/titled_nile_river_pop_small.png")
