library(tidyverse)
library(magick)
library(glue)
library(colorspace)

# Load `header` list with needed data
header <- readRDS("R/portraits/maine/header.rds")
colors <- header$colors
swatchplot(colors)

text_color <- colors[6]

img <- image_read(header$outfile)


shadow <- "#0a1832"




img |> 
  image_crop(geometry = "8500x8500-400-250", gravity = "center") |> 
  image_annotate(text = glue("Graphic: Spencer Schien (@MrPecners) | ",
                             "Kontur Population Data (Released June 30, 2022)"),
                 gravity = "south",
                 location = "+0+300", font = "Amarante",
                 color = alpha(text_color, .5),
                 kerning = 20,
                 size = 60, weight = 700) |> 
  image_write("images/maine/titled_me_pop.png")

system(
  glue("convert -size 6000x4000 xc:none -gravity Center ",
       
       "-stroke '{colors[1]}' -fill '{colors[1]}' ",
       "-pointsize 600 -kerning 250 -font Poller-One ",
       "-strokewidth 10 -annotate 0x5+0+0 'MAINE' ",
       "-distort Arc 10 -background none ",
       # "-gravity north -annotate +0+1000 'Population' ", 
       # "-gravity northeast -kerning 200 -annotate +500+200 'Density' ",
       # "-rotate -7 ",
       "-rotate -30 images/maine/titled_me_pop.png +swap ",
       "-gravity center -geometry -2000-2500 ",
       "-composite images/maine/titled_me_pop_one.png")
)

system(
  glue("convert -size 6000x4000 xc:none -gravity Center ",
       
       "-stroke '{colors[2]}' -fill '{colors[2]}' ",
       "-pointsize 250 -kerning 100 -font Amarante-Regular ",
       "-annotate +0+0 'POPULATION DENSITY' ",
       "-distort Arc 10 -background none +repage ",
       
       # "-fill '{colors[2]}' -stroke '{colors[2]}' -strokewidth 5 ",
       # "-annotate -3x0-1150+700 'Population Density' ",
       # "-gravity north -annotate +0+1000 'Population' ", 
       # "-gravity northeast -kerning 200 -annotate +500+200 'Density' ",
       "-rotate -30 images/maine/titled_me_pop_one.png +swap ",
       "-gravity center -geometry -1000-2100 ",
       "-composite images/maine/titled_me_pop_done.png")
)


image_read("images/maine/titled_me_pop_done.png") |> 
  image_scale(geometry = "42%x") |> 
  image_write("tracked_graphics/titled_me_pop_small.png")
