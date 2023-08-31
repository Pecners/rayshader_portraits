library(tidyverse)
library(magick)
library(glue)
library(colorspace)

# Load `header` list with needed data
header <- readRDS("R/portraits/north_dakota/header.rds")
colors <- header$colors
swatchplot(colors)

text_color <- colors[1]

img <- image_read(header$outfile)
image_info(img)

# annot <- glue("This map shows population density of ",
#               "{str_to_title('north_dakota')}. ",
#               "Population estimates are bucketed ",
#               "into 400 meter (about 1/4 mile) hexagons.") |> 
#   str_wrap(45)
# cat(annot)



img |> 
  # crop the image to desired dimensions
  image_crop(geometry = "10000x6666+0-250", gravity = "center") |> 
  image_write("images/north_dakota/titled_nd_pop.png")

# Use system() to make imagemagick calls manually
# This code chunk adds the "north_dakota" title
system(
  glue("convert -size 9000X6000 xc:none -gravity Center ",
       
       "-stroke '{text_color}' -fill '{text_color}' ",
       "-pointsize 400 -kerning 100 -font Poller-One ",
       "-strokewidth 10 -annotate -6x5-1500-2100 'NORTH DAKOTA' ",
       " -background none ",
       # "-gravity north -annotate +0+1000 'Population' ", 
       # "-gravity northeast -kerning 200 -annotate +500+200 'Density' ",
       "images/north_dakota/titled_nd_pop.png +swap ",
       "-composite images/north_dakota/titled_nd_pop_one.png")
)

system(
  glue("convert -size 9000x6000 xc:none -gravity Center ",
       
       
       "-stroke '{colors[3]}' -fill '{colors[3]}' ",
       "-pointsize 400 -kerning 100 -font Amarante-Regular ",
       "-annotate -6x5-750-1600 'Population Density' ",
       "-background none +repage ",
       
       # "-fill '{colors[2]}' -stroke '{colors[2]}' -strokewidth 5 ",
       # "-annotate -3x0-1150+700 'Population Density' ",
       # "-gravity north -annotate +0+1000 'Population' ", 
       # "-gravity northeast -kerning 200 -annotate +500+200 'Density' ",
       "images/north_dakota/titled_nd_pop_one.png +swap ",
       "-composite images/north_dakota/titled_nd_pop_done.png")
)

cap <- glue("Graphic: Spencer Schien (@MrPecners) | ",
            "Kontur Population Data (Released June 30, 2022)")

system(
  glue("convert -size 9000x6000 xc:none -gravity Center ",
       
       "-stroke '{alpha(colors[3], .5)}' -fill '{alpha(colors[3], .5)}' ",
       "-pointsize 60 -kerning 20 -font Amarante-Regular ",
       "-annotate -6x5-475-1400 '{cap}' ",
       "-background none +repage ",
       
       # "-fill '{colors[2]}' -stroke '{colors[2]}' -strokewidth 5 ",
       # "-annotate -3x0-1150+700 'Population Density' ",
       # "-gravity north -annotate +0+1000 'Population' ", 
       # "-gravity northeast -kerning 200 -annotate +500+200 'Density' ",
       "images/north_dakota/titled_nd_pop_done.png +swap ",
       "-composite images/north_dakota/titled_nd_pop_cap.png")
)


image_read("images/north_dakota/titled_nd_pop_cap.png") |> 
  image_scale(geometry = "46%x") |> 
  image_write("tracked_graphics/titled_nd_pop_small.png")
