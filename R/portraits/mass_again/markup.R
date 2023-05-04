library(tidyverse)
library(magick)
library(glue)
library(colorspace)

# Load `header` list with needed data
header <- readRDS("R/portraits/mass_again/header.rds")
colors <- header$colors
swatchplot(colors)

img <- image_read(header$outfile)
image_info(img)

text_color <- mixcolor(alpha = .75, color1 =  hex2RGB(colors[2]), 
                       color2 = hex2RGB(colors[1])) |> 
  hex()

text_color <- colors[1]
t2 <- mixcolor(alpha = .5, color1 =  hex2RGB(colors[9]), 
               color2 = hex2RGB(colors[8])) |> 
  hex()

img |> 
  image_crop(geometry = "9000x6000+0+500", gravity = "center") |> 
  # image_annotate(text = "massachusetts", 
  #                gravity = "center",
  #                location = "-1500-500", font = "Knewave",
  #                color = text_color,
  #                size = 600, kerning = 150, weight = 700) |> 
  # image_annotate(text = "Population Density",
  #                gravity = "center",
  #                location = "-1250-300", font = "Rock Salt",
  #                size = 200, color = colors[8], degrees = -10, 
  #                decoration = "underline") |> 
  image_annotate(text = glue("Graphic: Spencer Schien (@MrPecners) | ",
                             "Kontur Population Data (Released June 30, 2022)"),
                 gravity = "south",
                 location = "+0+100", font = "Amarante",
                 color = colors[9],
                 kerning = 20,
                 size = 60, weight = 700) |> 
  image_write("images/mass_again/titled_ma_pop.png")

system(
  glue("convert -size 9000x6000 xc:none -gravity Center ",
       "-stroke '{colors[9]}' -fill '{colors[9]}' ",
       "-pointsize 250 -kerning 100 -font Poller-One ",
       "-strokewidth 10 -annotate 15x5-1750+0 'MASSACHUSETTS' ",
       " -background none ",
       # "-gravity north -annotate +0+1000 'Population' ", 
       # "-gravity northeast -kerning 200 -annotate +500+200 'Density' ",
       "images/mass_again/titled_ma_pop.png +swap ",
       "-composite images/mass_again/titled_ma_pop_one.png")
)

system(
  glue("convert -size 9000x6000 xc:none -gravity Center ",
       
       "-stroke '{t2}' -fill '{t2}' -strokewidth 5 ",
       "-pointsize 250 -kerning 100 -font Amarante-Regular ",
       "-annotate 14x5-1500+600 'Population Density' ",
       "-background none +repage ",
       
       # "-fill '{colors[2]}' -stroke '{colors[2]}' -strokewidth 5 ",
       # "-annotate -3x0-1150+700 'Population Density' ",
       # "-gravity north -annotate +0+1000 'Population' ", 
       # "-gravity northeast -kerning 200 -annotate +500+200 'Density' ",
       "images/mass_again/titled_ma_pop_one.png +swap ",
       "-composite images/mass_again/titled_ma_pop_done.png")
)


image_read("images/mass_again/titled_ma_pop_done.png") |> 
  image_scale(geometry = "47%x") |> 
  image_write("tracked_graphics/titled_ma_again_pop_small.png")
