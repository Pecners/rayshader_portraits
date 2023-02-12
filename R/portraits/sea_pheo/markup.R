library(tidyverse)
library(magick)
library(glue)
library(colorspace)
library(svgparser)

# Load `header` list with needed data
header <- readRDS("R/portraits/sea_pheo/header.rds")
colors <- header$colors
swatchplot(colors)

text_color <- colors[7]

# compass
# Compass rose SVG from here: https://freesvg.org/compass-rose-vector-sketch
# I edited the SVG file to change fill from black to the palette blue
t_rose <- tempfile()


read_lines("R/portraits/michigan_pop/CompassRose.svg") |> 
  gsub(x = _, pattern = "#326812", colors[8]) |> 
  gsub(x = _, pattern = "#99ce64", colors[6]) |> 
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
                 color = colors[8]) |> 
  image_background(color = "none") |> 
  image_scale(geometry = "100%x66%") |> 
  image_rotate(20)

f_image


img <- image_read(header$outfile)


img |> 
  image_crop(geometry = "6000x6500+500+0", gravity = "center") |> 
  image_annotate(text = glue("Graphic: Spencer Schien (@MrPecners) | ",
                             "Kontur Population Data (Released June 30, 2022)"),
                 gravity = "south",
                 location = "+0+100", font = "El Messiri",
                 color = alpha(colors[7], .75),
                 kerning = 20,
                 size = 65, weight = 700) |> 
  image_composite(image_modulate(f_image, saturation = 75) |> 
                    image_scale("50%x"), 
                  gravity = "southeast", 
                  offset = "+500+500") |> 
  image_write("images/sea_pheo/titled_sea_pheo_pop.png")


system(
  glue("convert -size 6000x6500 xc:none ",
       # Shadows
       "-gravity northeast -font Cinzel-Decorative-Black ",
       "-pointsize 200 -kerning 150 -stroke '{colors[4]}' -fill '{colors[4]}' ",
       "-annotate +190+120 'Comparative' ",
       "-background none ",
       "-kerning 100 -annotate +190+620 'Population' ",
       "-background none ",
       "-kerning 50 -annotate +190+1120 'Density' ",
       "-background none -blur 50x30 +repage ",
       
       # Foreground font
       "-font Cinzel-Decorative-Black -stroke '{colors[4]}' -fill '{colors[7]}' ",
       "-pointsize 200 -kerning 150 -annotate +200+100 'Comparative' ", 
       "-kerning 100 -annotate +200+600 'Population' ", 
       "-kerning 50 -annotate +200+1100 'Density' ",
       "-gravity north -pointsize 75 ",
       "-font Cinzel-Decorative-Bold -stroke '{colors[9]}' ",
       "-annotate -35x0-1600+900 'Seattle' ",
       "-annotate 15x0-1100+3650 'Phoenix' ",
       "images/sea_pheo/titled_sea_pheo_pop.png +swap ",
       "-composite images/sea_pheo/titled_sea_pheo_pop_done.png")
)

image_read("images/sea_pheo/titled_sea_pheo_pop_done.png") |> 
  image_scale(geometry = "58%x") |> 
  image_write("tracked_graphics/titled_sea_pheo_pop_small.png")

