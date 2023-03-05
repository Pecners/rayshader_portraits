library(tidyverse)
library(magick)
library(glue)
library(colorspace)

# Load `header` list with needed data
header <- readRDS("R/portraits/wyoming/header.rds")
colors <- header$colors
swatchplot(colors)

text_color <- colors[1]

img <- image_read(header$outfile)


img |> 
  image_crop(geometry = "8000x5000+0+0", gravity = "center") |> 
  image_write("images/wyoming/titled_wy_pop.png")

cap <- glue("Graphic by Spencer Schien (@MrPecners) | ",
            "Kontur Population Data (Released June 30, 2022)")


system(
  glue("convert -size 8000x5000 xc:none ",
       # Shadows
       "-gravity north -font Marhey-Bold ",
       "-pointsize 300 -kerning 175 -stroke '{colors[1]}' -fill '{colors[1]}' ",
       "-annotate -5x20-1000+400 'WYOMING' ",
       "-background none -blur 500x100 ",
       "-pointsize 125 -kerning 100 ",
       "-annotate -6x20-1000+900 'Population Density' ",
       "-background none -blur 250x50 +repage ",
       
       "-stroke '{colors[4]}' -fill '{colors[4]}' ",
       "-pointsize 300 -kerning 175 -annotate -5x10-1000+400 'WYOMING' ", 
       "-pointsize 125 -kerning 100 ",
       "-annotate -6x20-1000+900 'Population Density' ",
       "-font Marhey -pointsize 55 -kerning 15 ",
       "-annotate -5.75x20+500+4000 '{cap}' ",
       "-rotate 180 -distort arc '3 180' ",
       # "-gravity north -annotate +0+1000 'Population' ", 
       # "-gravity northeast -kerning 200 -annotate +500+200 'Density' ",
       "images/wyoming/titled_wy_pop.png +swap ",
       "-composite images/wyoming/titled_wy_pop_done.png")
)

image_read("images/wyoming/titled_wy_pop_done.png") |> 
  image_scale(geometry = "69%x") |> 
  image_write("tracked_graphics/titled_wy_pop_small.png")

