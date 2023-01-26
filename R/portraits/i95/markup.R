library(tidyverse)
library(magick)
library(glue)
library(colorspace)
library(svgparser)

# Load `header` list with needed data
header <- readRDS("R/portraits/i95/header.rds")
colors <- header$colors
swatchplot(colors)

text_color <- colors[5]

img <- image_read(header$outfile)


annot <- glue("This map shows population density within 10 miles ",
              "of I-95. ",
              "Population estimates are bucketed ",
              "into 400 meter (about 1/4 mile) hexagons.") |> 
  str_wrap(35)
cat(annot)

# I-95 svg

i95_svg <- read_svg("R/portraits/i95/i95.svg")
tmp <- tempfile()
png(tmp, bg = "transparent")
grid::grid.newpage()
grid::grid.draw(i95_svg)
dev.off()

svg_tmp <- image_read(tmp)
svg_tmp
svg_tmp <- image_scale(svg_tmp, glue("x2000"))

img |> 
  image_crop(geometry = "9000x7000+0+700", gravity = "center") |> 
  image_annotate(text = "POPULATION DENSITY ALONG", 
                 gravity = "north",
                 location = "+2000+3000", 
                 font = "El Messiri",
                 color = text_color,
                 size = 300, 
                 weight = 700) |> 
  image_annotate(text = annot, gravity = "north",
                 location = "-1000+5500", font = "El Messiri",
                 color = alpha(text_color, .75),
                 size = 150) |> 
  image_annotate(text = glue("Graphic: Spencer Schien (@MrPecners) | ",
                             "Kontur Population Data (Released June 30, 2022)"),
                 gravity = "south",
                 location = "-1000+100", font = "El Messiri",
                 color = alpha(text_color, .5),
                 size = 80, weight = 700) |> 
  image_composite(svg_tmp, gravity = "north",
                  offset = "+2000+4000") |> 
  image_write("images/i95/titled_i95_pop.png")

image_read("images/i95/titled_i95_pop.png") |> 
  image_scale(geometry = "46%x") |> 
  image_write("tracked_graphics/titled_i95_pop_small.png")

