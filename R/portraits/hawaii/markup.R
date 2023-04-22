library(tidyverse)
library(magick)
library(glue)
library(colorspace)

# Load `header` list with needed data
header <- readRDS("R/portraits/hawaii/header.rds")
colors <- header$colors
swatchplot(colors)

img <- image_read(header$outfile)


text_color <- mixcolor(alpha = .75, color1 =  hex2RGB(colors[2]), 
                       color2 = hex2RGB(colors[1])) |> 
  hex()

img |> 
  image_crop(geometry = "8000x5500+0+500", gravity = "center") |> 
  # image_annotate(text = "HAWAII", 
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
                 location = "+0+100", font = "Kaushan Script",
                 color = alpha(text_color, .5),
                 kerning = 20,
                 size = 60, weight = 700) |> 
  image_write("images/hawaii/titled_hi_pop.png")

system(
  glue("convert -size 6500x6200 xc:none -gravity Center ",
       
       "-stroke '{text_color}' -fill '{text_color}' -strokewidth 12 ",
       "-pointsize 650 -kerning 150 -font Knewave ",
       "-strokewidth 10 -annotate -3x0-1750+0 'HAWAII' ",
       "-distort arc 30 -background none ",
       # "-gravity north -annotate +0+1000 'Population' ", 
       # "-gravity northeast -kerning 200 -annotate +500+200 'Density' ",
       "images/hawaii/titled_hi_pop.png +swap ",
       "-composite images/hawaii/titled_hi_pop_one.png")
)

system(
  glue("convert -size 6500x6200 xc:none -gravity Center ",
       
       
       "-stroke '{text_color}' -fill '{text_color}' ",
       "-pointsize 450 -font Kaushan-Script ",
       "-annotate -3x0-1150+700 'Population Density' ",
       "-background none +repage ",
       
       "-fill '{colors[2]}' -stroke '{colors[2]}' -strokewidth 5 ",
       "-annotate -3x0-1150+700 'Population Density' ",
       "-distort arc 30 ",
       # "-gravity north -annotate +0+1000 'Population' ", 
       # "-gravity northeast -kerning 200 -annotate +500+200 'Density' ",
       "images/hawaii/titled_hi_pop_one.png +swap ",
       "-composite images/hawaii/titled_hi_pop_done.png")
)


image_read("images/hawaii/titled_hi_pop_done.png") |> 
  image_scale(geometry = "53%x") |> 
  image_write("tracked_graphics/titled_hi_pop_small.png")
