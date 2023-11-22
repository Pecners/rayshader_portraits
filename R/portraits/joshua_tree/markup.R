library(tidyverse)
library(magick)
library(glue)
library(colorspace)

# Load `header` list with needed data
header <- readRDS("R/portraits/joshua_tree/header.rds")

colors <- header$colors
swatchplot(colors)

text_color <- colors[8]

img <- image_read(header$outfile)
image_info(img)

img |> 
  # image_crop(geometry = "8000x12000-600+0", gravity = "center") |> 
  image_crop(geometry = "5000x4000+0-400", gravity = "center") |> 
  image_write("images/joshua_tree/titled_jt.png")

system(
  glue("convert -size 4000x2000 xc:none -gravity Center ",
       
       "-stroke '{text_color}' -fill '{text_color}' ",
       "-pointsize 275 -kerning 100 -font Poller-One ",
       "-strokewidth 10 -annotate 0x10+0+0 'Joshua Tree' ",
       "-distort Arc 75 -background none ",
       # "-gravity north -annotate +0+1000 'Population' ", 
       # "-gravity northeast -kerning 200 -annotate +500+200 'Density' ",
       # "-rotate -7 ",
       "images/joshua_tree/titled_jt.png +swap ",
       "-gravity center -geometry +0-1400 ",
       "-composite images/joshua_tree/titled_jt_one.png")
)

system(
  glue("convert -size 4000x2000 xc:none -gravity Center ",
       
       
       "-stroke '{colors[7]}' -fill '{colors[7]}' ",
       "-pointsize 200 -kerning 75 -font El-Messiri-Regular ",
       "-annotate +0+0 'NATIONAL PARK' ",
       "-rotate 180 -distort Arc '60 180' -background none +repage ",
       
       # "-fill '{colors[2]}' -stroke '{colors[2]}' -strokewidth 5 ",
       # "-annotate -3x0-1150+700 'Population Density' ",
       # "-gravity north -annotate +0+1000 'Population' ", 
       # "-gravity northeast -kerning 200 -annotate +500+200 'Density' ",
       "images/joshua_tree/titled_jt_one.png +swap ",
       "-gravity center -geometry +0-1000 ",
       "-composite images/joshua_tree/titled_jt_done.png")
)

cap <- glue("Graphic: Spencer Schien (@MrPecners) | ",
            "Data from National Park Service")

system(
  glue("convert -size 4000x2000 xc:none -gravity Center ",
       
       
       "-stroke '{colors[8]}' -fill '{colors[8]}' ",
       "-pointsize 40 -kerning 17 -font El-Messiri-Regular ",
       "-annotate +0+0 '{cap}' ",
       "-rotate 180 -distort Arc '60 180' -background none +repage ",
       
       # "-fill '{colors[2]}' -stroke '{colors[2]}' -strokewidth 5 ",
       # "-annotate -3x0-1150+700 'Population Density' ",
       # "-gravity north -annotate +0+1000 'Population' ", 
       # "-gravity northeast -kerning 200 -annotate +500+200 'Density' ",
       "images/joshua_tree/titled_jt_done.png +swap ",
       "-gravity center -geometry +0-900 ",
       "-composite images/joshua_tree/titled_jt_done_cap.png")
)


image_read("images/joshua_tree/titled_jt_done_cap.png") |> 
  image_scale(geometry = "75%x") |> 
  image_write("tracked_graphics/titled_jt_small.png")
