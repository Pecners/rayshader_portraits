library(tidyverse)
library(magick)
library(glue)
library(colorspace)

# Load `header` list with needed data
header <- readRDS("R/portraits/delaware/header.rds")
colors <- header$colors
swatchplot(colors)

text_color <- colors[4]

img <- image_read(header$outfile)


shadow <- "#0a1832"


img |> 
  # image_crop(geometry = "8000x12000-600+0", gravity = "center") |> 
  image_crop(geometry = "9000x9000+0+0", gravity = "center") |> 
  image_write("images/delaware/titled_de_pop.png")

system(
  glue("convert -size 4000x2000 xc:none -gravity Center ",
       
       "-stroke '{text_color}' -fill '{text_color}' ",
       "-pointsize 400 -kerning 100 -font Poller-One ",
       "-strokewidth 10 -annotate 0x5+0+0 'DELAWARE' ",
       "-distort Arc 75 -background none ",
       # "-gravity north -annotate +0+1000 'Population' ", 
       # "-gravity northeast -kerning 200 -annotate +500+200 'Density' ",
       # "-rotate -7 ",
       "images/delaware/titled_de_pop.png +swap ",
       "-gravity center -geometry +2200-750 ",
       "-composite images/delaware/titled_de_pop_one.png")
)

system(
  glue("convert -size 4000x2000 xc:none -gravity Center ",
       
       
       "-stroke '{colors[3]}' -fill '{colors[3]}' ",
       "-pointsize 200 -kerning 100 -font Amarante-Regular ",
       "-annotate +0+0 'Population Density' ",
       "-rotate 180 -distort Arc '75 180' -background none +repage ",
       
       # "-fill '{colors[2]}' -stroke '{colors[2]}' -strokewidth 5 ",
       # "-annotate -3x0-1150+700 'Population Density' ",
       # "-gravity north -annotate +0+1000 'Population' ", 
       # "-gravity northeast -kerning 200 -annotate +500+200 'Density' ",
       "images/delaware/titled_de_pop_one.png +swap ",
       "-gravity center -geometry +2200+50 ",
       "-composite images/delaware/titled_de_pop_done.png")
)

cap <- glue("Graphic: Spencer Schien (@MrPecners) | ",
            "Kontur Population Data (Released June 30, 2022)")

system(
  glue("convert -size 4000x2000 xc:none -gravity Center ",
       
       
       "-stroke '{colors[3]}' -fill '{colors[3]}' ",
       "-pointsize 50 -kerning 15 -font Amarante-Regular ",
       "-annotate +0+0 '{cap}' ",
       "-rotate 180 -distort Arc '75 180' -background none +repage ",
       
       # "-fill '{colors[2]}' -stroke '{colors[2]}' -strokewidth 5 ",
       # "-annotate -3x0-1150+700 'Population Density' ",
       # "-gravity north -annotate +0+1000 'Population' ", 
       # "-gravity northeast -kerning 200 -annotate +500+200 'Density' ",
       "images/delaware/titled_de_pop_done.png +swap ",
       "-gravity center -geometry +2200+300 ",
       "-composite images/delaware/titled_de_pop_done_cap.png")
)


image_read("images/delaware/titled_de_pop_done_cap.png") |> 
  image_scale(geometry = "43%x") |> 
  image_write("tracked_graphics/titled_de_pop_small.png")
