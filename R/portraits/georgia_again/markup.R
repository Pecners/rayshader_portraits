library(tidyverse)
library(magick)
library(glue)
library(colorspace)

# Load `header` list with needed data
header <- readRDS("R/portraits/georgia_again/header.rds")
colors <- header$colors
swatchplot(colors)

text_color <- colors[9]

img <- image_read(header$outfile)
image_info(img)

img |> 
  # image_crop(geometry = "8000x12000-600+0", gravity = "center") |> 
  image_crop(geometry = "8500x6375+0+0", gravity = "center") |> 
  image_write("images/georgia_again/titled_ga_pop.png")

system(
  glue("convert -size 4000x2000 xc:none -gravity Center ",
       
       "-stroke '{text_color}' -fill '{text_color}' ",
       "-pointsize 400 -kerning 150 -font Poller-One ",
       "-strokewidth 10 -annotate 0x5+0+0 'GEORGIA' ",
       "-distort Arc 75 -background none ",
       # "-gravity north -annotate +0+1000 'Population' ", 
       # "-gravity northeast -kerning 200 -annotate +500+200 'Density' ",
       # "-rotate -7 ",
       "images/georgia_again/titled_ga_pop.png +swap ",
       "-gravity center -geometry +1900-2200 ",
       "-composite images/georgia_again/titled_ga_pop_one.png")
)

system(
  glue("convert -size 4000x2000 xc:none -gravity Center ",
       
       
       "-stroke '{colors[8]}' -fill '{colors[8]}' ",
       "-pointsize 180 -kerning 75 -font El-Messiri-Regular ",
       "-annotate +0+0 'POPULATION DENSITY' ",
       "-rotate 180 -distort Arc '60 180' -background none +repage ",
       
       # "-fill '{colors[2]}' -stroke '{colors[2]}' -strokewidth 5 ",
       # "-annotate -3x0-1150+700 'Population Density' ",
       # "-gravity north -annotate +0+1000 'Population' ", 
       # "-gravity northeast -kerning 200 -annotate +500+200 'Density' ",
       "images/georgia_again/titled_ga_pop_one.png +swap ",
       "-gravity center -geometry +1900-1600 ",
       "-composite images/georgia_again/titled_ga_pop_done.png")
)

cap <- glue("Graphic: Spencer Schien (@MrPecners) | ",
            "Kontur Population Data (Released June 30, 2022)")

system(
  glue("convert -size 4000x2000 xc:none -gravity Center ",
       
       
       "-stroke '{colors[9]}' -fill '{colors[9]}' ",
       "-pointsize 50 -kerning 15 -font El-Messiri-Regular ",
       "-annotate +0+0 '{cap}' ",
       "-rotate 180 -distort Arc '60 180' -background none +repage ",
       
       # "-fill '{colors[2]}' -stroke '{colors[2]}' -strokewidth 5 ",
       # "-annotate -3x0-1150+700 'Population Density' ",
       # "-gravity north -annotate +0+1000 'Population' ", 
       # "-gravity northeast -kerning 200 -annotate +500+200 'Density' ",
       "images/georgia_again/titled_ga_pop_done.png +swap ",
       "-gravity center -geometry +1900-1450 ",
       "-composite images/georgia_again/titled_ga_pop_done_cap.png")
)


image_read("images/georgia_again/titled_ga_pop_done_cap.png") |> 
  image_scale(geometry = "43%x") |> 
  image_write("tracked_graphics/titled_ga_pop_small.png")
