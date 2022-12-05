library(tidyverse)
library(svgparser)
library(magick)

# Load `header` list with needed data
header <- readRDS("R/portraits/georgia/header.rds")
colors <- header$colors
swatchplot(colors)

# Take original graphic from `render_highquality` and
# add annotations.

# compass
# Compass rose SVG from here: https://freesvg.org/compass-rose-vector-sketch
# I edited the SVG file to change fill from black to the palette blue
t_rose <- tempfile()
text_color <- darken(colors[2], .5)


read_lines("R/portraits/michigan_pop/CompassRose.svg") |> 
  gsub(x = _, pattern = "#326812", text_color) |> 
  gsub(x = _, pattern = "#99ce64", colors[2]) |> 
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
  image_scale(geometry = "100%x77%") |> 
  image_rotate(-20)

f_image

img <- image_read(header$outfile)

# text_color <- darken(text_color, .25)

annot <- glue("This map shows population density of Georgia. ",
              "Population estimates are bucketed ",
              "into 400 meter (about 1/4 mile) hexagons.") |> 
  str_wrap(65)



img |> 
  image_crop(geometry = "5500x4750+0+250", gravity = "southwest") |> 
  image_annotate(text = "Georgia Population Density", gravity = "northeast",
                 location = "+200+100", font = "El Messiri",
                 color = text_color,
                 size = 200, weight = 700) |> 
  image_annotate(text = annot, gravity = "southwest",
                 location = "+200+65", font = "El Messiri",
                 color = alpha(text_color, .75),
                 size = 125) |> 
  image_annotate(text = "Data: Kontur Population Data", gravity = "southeast",
                 location = "+200+200", font = "El Messiri",
                 color = alpha(text_color, .5),
                 size = 60, weight = 700) |> 
  image_annotate(text = "Graphic: Spencer Schien (@MrPecners)", gravity = "southeast",
                 location = "+200+100", font = "El Messiri",
                 color = alpha(text_color, .5),
                 size = 60, weight = 700) |> 
  image_composite(image_modulate(f_image, saturation = 50) |> 
                    image_scale("50%x"), 
                  gravity = "west", 
                  offset = "+400+1000") |> 
  image_write("images/georgia/titled_ga_pop.png")

image_read("images/georgia/titled_ga_pop.png") |> 
  image_scale(geometry = "74%x") |> 
  image_write("tracked_graphics/titled_ga_pop_small.png")

