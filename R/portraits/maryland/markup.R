library(tidyverse)
library(magick)
library(glue)
library(colorspace)

# Load `header` list with needed data
header <- readRDS("R/portraits/maryland/header.rds")
colors <- header$colors
swatchplot(colors)

text_color <- colors[8]

img <- image_read(header$outfile)


shadow <- "#0a1832"
  

img |> 
  image_crop(geometry = "9500x6333+0+250", gravity = "center") |> 
  image_annotate(text = glue("Graphic: Spencer Schien (@MrPecners) | ",
                             "Kontur Population Data (Released June 30, 2022)"),
                 gravity = "south",
                 location = "+0+200", font = "Amarante",
                 color = alpha(text_color, .5),
                 kerning = 20,
                 size = 60, weight = 700) |> 
  image_write("images/maryland/titled_md_pop.png")

system(
  glue("convert -size 4000x2000 xc:none -gravity Center ",
       
       "-stroke '{text_color}' -fill '{text_color}' ",
       "-pointsize 400 -kerning 100 -font Poller-One ",
       "-strokewidth 10 -annotate 0x5+0+0 'MARYLAND' ",
       "-distort Arc 60 -background none ",
       # "-gravity north -annotate +0+1000 'Population' ", 
       # "-gravity northeast -kerning 200 -annotate +500+200 'Density' ",
       # "-rotate -7 ",
       "images/maryland/titled_md_pop.png +swap ",
       "-gravity center -geometry -2000+0 ",
       "-composite images/maryland/titled_md_pop_one.png")
)

system(
  glue("convert -size 4000x2000 xc:none -gravity Center ",
       
       
       "-stroke '{colors[7]}' -fill '{colors[7]}' ",
       "-pointsize 200 -kerning 100 -font Amarante-Regular ",
       "-annotate +0+0 'Population Density' ",
       "-rotate 180 -distort Arc '60 178' -background none +repage ",
       
       # "-fill '{colors[2]}' -stroke '{colors[2]}' -strokewidth 5 ",
       # "-annotate -3x0-1150+700 'Population Density' ",
       # "-gravity north -annotate +0+1000 'Population' ", 
       # "-gravity northeast -kerning 200 -annotate +500+200 'Density' ",
       "images/maryland/titled_md_pop_one.png +swap ",
       "-gravity center -geometry -2000+750 ",
       "-composite images/maryland/titled_md_pop_done.png")
)


image_read("images/maryland/titled_md_pop_done.png") |> 
  image_scale(geometry = "47%x") |> 
  image_write("tracked_graphics/titled_md_pop_small.png")
