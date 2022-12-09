library(tidyverse)
library(svgparser)
library(magick)

# Load `header` list with needed data
header <- readRDS("R/portraits/pennsylvania/header.rds")
colors <- header$colors
swatchplot(colors)

# Take original graphic from `render_highquality` and
# add annotations.

# compass
# Compass rose SVG from here: https://freesvg.org/compass-rose-vector-sketch
# I edited the SVG file to change fill from black to the palette blue
t_rose <- tempfile()
text_color <- darken(colors[5], .25)


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
  image_scale(geometry = "100%x71%") |> 
  image_rotate(-30)

f_image

img <- image_read(header$outfile)


annot <- glue("This map shows population density of Pennsylvania. ",
              "Population estimates are bucketed ",
              "into 400 meter (about 1/4 mile) hexagons.") |> 
  str_wrap(47)



img |> 
  image_crop(geometry = "6000x4000+0+400", gravity = "center") |> 
  image_annotate(text = "Pennsylvania Population Density", gravity = "northwest",
                 location = "+100+100", font = "El Messiri",
                 color = text_color,
                 size = 200, weight = 700) |> 
  image_annotate(text = annot, gravity = "southeast",
                 location = "+100+60", font = "El Messiri",
                 color = alpha(text_color, .75),
                 size = 125) |> 
  image_annotate(text = "Data: Kontur Population Data (Released June 30, 2022)", gravity = "southwest",
                 location = "+100+100", font = "El Messiri",
                 color = alpha(text_color, .5),
                 size = 60, weight = 700) |> 
  image_annotate(text = "Graphic: Spencer Schien (@MrPecners)", gravity = "southwest",
                 location = "+100+200", font = "El Messiri",
                 color = alpha(text_color, .5),
                 size = 60, weight = 700) |> 
  # image_composite(image_modulate(f_image, saturation = 50) |>
  #                   image_scale("50%x"),
  #                 gravity = "southwest",
  #                 offset = "+400+700") |>
  image_write("images/pennsylvania/titled_pa_pop.png")

