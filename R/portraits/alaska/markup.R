library(tidyverse)
library(magick)
library(glue)
library(colorspace)

# Load `header` list with needed data
header <- readRDS("R/portraits/alaska/header.rds")
colors <- header$colors
swatchplot(colors)

text_color <- colors[8]

img <- image_read(header$outfile)


shadow <- "#0a1832"

cap <- glue("Graphic: Spencer Schien (@MrPecners) | ",
            "Kontur Population Data (Released June 30, 2022)")


img |> 
  image_crop(geometry = "12000x8000+500+250", gravity = "east") |> 
  # image_annotate(text = glue("Graphic: Spencer Schien (@MrPecners) | ",
  #                            "Kontur Population Data (Released June 30, 2022)"),
  #                gravity = "south",
  #                location = "+0+200", font = "Amarante",
  #                color = alpha(text_color, .5),
  #                kerning = 20,
  #                size = 60, weight = 700) |> 
  image_write("images/alaska/titled_ak_pop.png")

system(
  glue("convert -size 4500x4000 xc:none -gravity Center ",
       
       "-stroke '{text_color}' -fill '{text_color}' ",
       "-pointsize 600 -kerning 300 -font Poller-One ",
       "-strokewidth 10 -annotate 0x5+0+0 'ALASKA' ",
       "-distort Arc 15 -background none ",
       # "-gravity north -annotate +0+1000 'Population' ", 
       # "-gravity northeast -kerning 200 -annotate +500+200 'Density' ",
       # "-rotate -7 ",
       "-rotate -15 images/alaska/titled_ak_pop.png +swap ",
       "-gravity center -geometry -2500-2500 ",
       "-composite images/alaska/titled_ak_pop_one.png")
)

system(
  glue("convert -size 6000x4000 xc:none -gravity Center ",
       
       "-stroke '{colors[7]}' -fill '{colors[7]}' ",
       "-pointsize 300 -kerning 150 -font Amarante-Regular ",
       "-annotate +0+0 'POPULATION DENSITY' ",
       "-distort Arc 20 -background none +repage ",
       
       # "-fill '{colors[2]}' -stroke '{colors[2]}' -strokewidth 5 ",
       # "-annotate -3x0-1150+700 'Population Density' ",
       # "-gravity north -annotate +0+1000 'Population' ", 
       # "-gravity northeast -kerning 200 -annotate +500+200 'Density' ",
       "-rotate -15 images/alaska/titled_ak_pop_one.png +swap ",
       "-gravity center -geometry -1800-1900 ",
       "-composite images/alaska/titled_ak_pop_done.png")
)

system(
  glue("convert -size 9000x4000 xc:none -gravity North ",
       
       "-stroke '{alpha(text_color, .25)}' -fill '{alpha(text_color, .25)}' ",
       "-pointsize 80 -kerning 20 -font Amarante-Regular ",
       "-annotate +2000+3800 '{cap}' ",
       "-distort arc 110  -background none +repage ",
       
       # "-fill '{colors[2]}' -stroke '{colors[2]}' -strokewidth 5 ",
       # "-annotate -3x0-1150+700 'Population Density' ",
       # "-gravity north -annotate +0+1000 'Population' ", 
       # "-gravity northeast -kerning 200 -annotate +500+200 'Density' ",
       "-rotate -30 images/alaska/titled_ak_pop_done.png +swap ",
       "-gravity south -geometry +1300-250 ",
       "-composite images/alaska/titled_ak_pop_done_cap.png")
)


image_read("images/alaska/titled_ak_pop_done_cap.png") |> 
  image_scale(geometry = "43%x") |> 
  image_write("tracked_graphics/titled_ak_pop_small.png")
