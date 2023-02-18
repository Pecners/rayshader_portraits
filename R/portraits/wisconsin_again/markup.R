library(tidyverse)
library(magick)
library(glue)
library(colorspace)

# Load `header` list with needed data
header <- readRDS("R/portraits/wisconsin_again/header.rds")
colors <- header$colors
swatchplot(colors)

text_color <- colors[1]

img <- image_read(header$outfile)



img |> 
  image_crop(geometry = "8000x6500+0+200", gravity = "center") |> 
  image_annotate(text = glue("Graphic: Spencer Schien (@MrPecners) | ",
                             "Kontur Population Data (Released June 30, 2022)"),
                 gravity = "south",
                 location = "+0+100", font = "El Messiri",
                 color = alpha(colors[8], .75),
                 kerning = 20,
                 size = 65, weight = 700) |> 
  image_write("images/wisconsin_again/titled_wi_pop.png")

system(
  glue("convert -size 8000x6500 xc:none ",
       # Shadows
       "-gravity northwest -font Cinzel-Decorative-Black ",
       "-pointsize 250 -kerning 100 -stroke '{colors[4]}' -fill '{colors[4]}' ",
       "-annotate +520+210 'Wisconsin' ",
       "-background none ",
       "-gravity north -kerning 100 -annotate +20+610 'Population' ",
       "-background none ",
       "-gravity northeast -kerning 200 -annotate +480+1010 'Density' ",
       "-background none -blur 50x30 +repage ",
       
       # Foreground font
       "-gravity northwest ",
       "-font Cinzel-Decorative-Black -stroke '{colors[9]}' -fill '{colors[7]}' ",
       "-gravity northwest -kerning 100 -annotate +500+200 'Wisconsin' ", 
       "-gravity north -kerning 100 -annotate +0+600 'Population' ", 
       "-gravity northeast -kerning 200 -annotate +500+1000 'Density' ",
       "images/wisconsin_again/titled_wi_pop.png +swap ",
       "-composite images/wisconsin_again/titled_wi_pop_done.png")
)

image_read("images/wisconsin_again/titled_wi_pop.png") |> 
  image_scale(geometry = "49%x") |> 
  image_write("tracked_graphics/titled_wi_again_pop_small.png")

