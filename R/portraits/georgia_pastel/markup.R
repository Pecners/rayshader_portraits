library(tidyverse)
library(magick)
library(glue)
library(colorspace)

# Load `header` list with needed data
header <- readRDS("R/portraits/georgia_pastel/header.rds")
colors <- header$colors
swatchplot(colors)

text_color <- colors[5] |> darken(.15)

text_color <- "#112A46"

img <- image_read(header$outfile)
image_info(img)

img |> 
  # image_crop(geometry = "8000x12000-600+0", gravity = "center") |> 
  image_crop(geometry = "8500x6375+0+0", gravity = "center") |> 
  image_write("images/georgia_pastel/titled_ga_pop.png")

system(
  glue("convert -size 4000x2000 xc:none -gravity Center ",
       
       "-stroke '{'black'}' -fill '{text_color}' ",
       "-pointsize 400 -kerning 175 -font Poller-One ",
       "-strokewidth 10 -annotate 0x5+0+0 'GEORGIA' ",
       "-distort Arc 75 -background none ",
       # "-gravity north -annotate +0+1000 'Population' ", 
       # "-gravity northeast -kerning 200 -annotate +500+200 'Density' ",
       # "-rotate -7 ",
       "images/georgia_pastel/titled_ga_pop.png +swap ",
       "-gravity center -geometry +1900-2300 ",
       "-composite images/georgia_pastel/titled_ga_pop_one.png")
)

system(
  glue("convert -size 4000x2000 xc:none -gravity Center ",
       
       "-strokewidth 2 ",
       "-stroke '{'grey15'}' -fill '{'grey15'}' ",
       "-pointsize 250 -kerning 35 -font El-Messiri-Bold ",
       "-annotate +0+0 'POPULATION DENSITY' ",
       "-rotate 180 -distort Arc '60 180' -background none +repage ",
       
       # "-fill '{colors[2]}' -stroke '{colors[2]}' -strokewidth 5 ",
       # "-annotate -3x0-1150+700 'Population Density' ",
       # "-gravity north -annotate +0+1000 'Population' ", 
       # "-gravity northeast -kerning 200 -annotate +500+200 'Density' ",
       "images/georgia_pastel/titled_ga_pop_one.png +swap ",
       "-gravity center -geometry +1900-1600 ",
       "-composite images/georgia_pastel/titled_ga_pop_done.png")
)

cap <- glue("Graphic: Spencer Schien (@MrPecners) | ",
            "Kontur Population Data (Released June 30, 2022)")

system(
  glue("convert -size 4000x2000 xc:none -gravity Center ",
       
       
       "-stroke '{'black'}' -fill '{'black'}' ",
       "-pointsize 50 -kerning 16 -font El-Messiri-Regular ",
       "-annotate +0+0 '{cap}' ",
       "-rotate 180 -distort Arc '60 180' -background none +repage ",
       
       # "-fill '{colors[2]}' -stroke '{colors[2]}' -strokewidth 5 ",
       # "-annotate -3x0-1150+700 'Population Density' ",
       # "-gravity north -annotate +0+1000 'Population' ", 
       # "-gravity northeast -kerning 200 -annotate +500+200 'Density' ",
       "images/georgia_pastel/titled_ga_pop_done.png +swap ",
       "-gravity center -geometry +1900-1450 ",
       "-composite images/georgia_pastel/titled_ga_pop_done_cap.png")
)


image_read("images/georgia_pastel/titled_ga_pop_done_cap.png") |> 
  image_scale(geometry = "43%x") |> 
  image_write("tracked_graphics/titled_ga_pastel_pop_small.png")
