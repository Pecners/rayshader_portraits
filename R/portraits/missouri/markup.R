library(tidyverse)
library(magick)
library(glue)
library(colorspace)

# Load `header` list with needed data
header <- readRDS("R/portraits/missouri/header.rds")
colors <- header$colors
swatchplot(colors)

text_color <- colors[1]

img <- image_read(header$outfile)

img |> 
  image_crop(geometry = "8000x5000+0+0", gravity = "center") |> 
  image_write("images/missouri/titled_mo_pop.png")

system(
  glue("convert -size 8000x5000 xc:none ",
       # Shadows
       "-gravity north -font Marhey-Bold ",
       "-pointsize 300 -kerning 175 -stroke '{colors[5]}' -fill '{colors[5]}' ",
       "-annotate +2000+200 'MISSOURI' ",
       "-background none ",
       "-pointsize 125 -kerning 100 ",
       "-annotate +2000+700 'Population Density' ",
       "-background none -blur 500x100 +repage ",
       
       "-pointsize 300 -kerning 175 -annotate +2000+200 'MISSOURI' ", 
       "-pointsize 125 -kerning 100 ",
       "-annotate +2000+700 'Population Density' ",
       "-gravity northwest ",
       "-font Marhey -pointsize 50 -kerning 25 -fill '{alpha(colors[5], .5)}' ",
       "-stroke '{alpha(colors[5], .5)}' -annotate ", 
       "64x20+1960+2850 'Graphic by Spencer Schien (@MrPecners)' ",
       "-annotate -14.5x20+2900+4600 'Kontur Population Data (Released June 30, 2022)' ",
       # "-gravity north -annotate +0+1000 'Population' ", 
       # "-gravity northeast -kerning 200 -annotate +500+200 'Density' ",
       "images/missouri/titled_mo_pop.png +swap ",
       "-composite images/missouri/titled_mo_pop_done.png")
)


image_read("images/missouri/titled_mo_pop_done.png") |> 
  image_scale(geometry = "60%x") |> 
  image_write("tracked_graphics/titled_mo_pop_small.png")

