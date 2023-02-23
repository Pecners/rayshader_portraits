library(tidyverse)
library(magick)
library(glue)
library(colorspace)

# Load `header` list with needed data
header <- readRDS("R/portraits/utah/header.rds")
colors <- header$colors
swatchplot(colors)

text_color <- colors[1]

img <- image_read(header$outfile)

cap <- glue("Graphic: Spencer Schien (@MrPecners) | ",
            "Kontur Population Data (Released June 30, 2022)")


img |> 
  image_crop(geometry = "7500x6000+0+400", gravity = "center") |> 
  image_write("images/utah/titled_ut_pop.png")

system(
  glue("convert -size 7500x6000 xc:none ",
       # Shadows
       "-gravity northwest -font Marhey-Bold ",
       "-pointsize 300 -kerning 200 -stroke '{colors[5]}' -fill '{colors[5]}' ",
       # "-annotate -7x40+560+990 'Nebraska Population Density' ",
       # # "-background none ",
       # # "-gravity north -annotate -20+990 'Population' ",
       # # "-background none ",
       # # "-gravity northeast -kerning 200 -annotate +520+190 'Density' ",
       # "-background none -blur 50x50 +repage ",
       "-annotate -14x20+800+800 'UTAH' ", 
       "-pointsize 150 -kerning 75 ",
       "-annotate 61x20+5600+1000 'Population Density' ",
       "-font Marhey -pointsize 80 -kerning 25 -fill '{alpha(colors[5], .5)}' ",
       "-stroke '{alpha(colors[5], .5)}' -annotate ", 
       "66x20+1350+3225 'Graphic by Spencer Schien (@MrPecners)' ",
       "-annotate -14x20+2450+5550 'Kontur Population Data (Released June 30, 2022)' ",
       # "-gravity north -annotate +0+1000 'Population' ", 
       # "-gravity northeast -kerning 200 -annotate +500+200 'Density' ",
       "images/utah/titled_ut_pop.png +swap ",
       "-composite images/utah/titled_ut_pop_done.png")
)

image_read("images/utah/titled_ut_pop_done.png") |> 
  image_scale(geometry = "56%x") |> 
  image_write("tracked_graphics/titled_ut_pop_small.png")

