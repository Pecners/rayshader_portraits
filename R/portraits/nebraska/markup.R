library(tidyverse)
library(magick)
library(glue)
library(colorspace)

# Load `header` list with needed data
header <- readRDS("R/portraits/nebraska/header.rds")
colors <- header$colors
swatchplot(colors)

text_color <- colors[1]

img <- image_read(header$outfile)

cap <- glue("Graphic: Spencer Schien (@MrPecners) | ",
            "Kontur Population Data (Released June 30, 2022)")


img |> 
  image_crop(geometry = "10000x6000+0+400", gravity = "center") |> 
  image_write("images/nebraska/titled_ne_pop.png")

system(
  glue("convert -size 10000x7000 xc:none ",
       # Shadows
       "-gravity northwest -font Marhey-Bold ",
       "-pointsize 200 -kerning 125 -stroke '{colors[1]}' -fill '{colors[1]}' ",
       # "-annotate -7x40+560+990 'Nebraska Population Density' ",
       # # "-background none ",
       # # "-gravity north -annotate -20+990 'Population' ",
       # # "-background none ",
       # # "-gravity northeast -kerning 200 -annotate +520+190 'Density' ",
       # "-background none -blur 50x50 +repage ",
       # 
       # Foreground font
       "-gravity northwest ",
       "-fill '{colors[1]}' -stroke '{colors[1]}' ",
       "-gravity northwest -kerning 125 ", 
       "-annotate -7x20+500+1500 'Nebraska Population Density' ", 
       "-font Marhey -pointsize 80 -kerning 25 -fill '{alpha(colors[1], .5)}' ",
       "-stroke '{alpha(colors[1], .5)}' -annotate -7x20+3500+4700 '{cap}' ",
       # "-gravity north -annotate +0+1000 'Population' ", 
       # "-gravity northeast -kerning 200 -annotate +500+200 'Density' ",
       "images/nebraska/titled_ne_pop.png +swap ",
       "-composite images/nebraska/titled_ne_pop_done.png")
)

image_read("images/nebraska/titled_ne_pop_done.png") |> 
  image_scale(geometry = "49%x") |> 
  image_write("tracked_graphics/titled_ne_pop_small.png")

