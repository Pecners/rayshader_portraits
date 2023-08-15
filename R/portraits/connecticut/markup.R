library(tidyverse)
library(magick)
library(glue)
library(colorspace)

# Load `header` list with needed data
header <- readRDS("R/portraits/connecticut/header.rds")
colors <- header$colors
swatchplot(colors)

text_color <- colors[4]

img <- image_read(header$outfile)
image_info(img)

# annot <- glue("This map shows population density of ",
#               "{str_to_title('connecticut')}. ",
#               "Population estimates are bucketed ",
#               "into 400 meter (about 1/4 mile) hexagons.") |> 
#   str_wrap(45)
# cat(annot)



img |> 
  # crop the image to desired dimensions
  image_crop(geometry = "8000x6000+0-250", gravity = "center") |> 
  image_write("images/connecticut/titled_ct_pop.png")

# Use system() to make imagemagick calls manually
# This code chunk adds the "connecticut" title
system(
  glue("convert -size 8000X6000 xc:none -gravity Center ",
       
       "-stroke '{text_color}' -fill '{text_color}' ",
       "-pointsize 300 -kerning 100 -font Poller-One ",
       "-strokewidth 10 -annotate -10.2x5-1750-2000 'CONNECTICUT' ",
       " -background none ",
       # "-gravity north -annotate +0+1000 'Population' ", 
       # "-gravity northeast -kerning 200 -annotate +500+200 'Density' ",
       "images/connecticut/titled_ct_pop.png +swap ",
       "-composite images/connecticut/titled_ct_pop_one.png")
)

system(
  glue("convert -size 8000x6000 xc:none -gravity Center ",
       
       
       "-stroke '{colors[3]}' -fill '{colors[3]}' ",
       "-pointsize 300 -kerning 100 -font Amarante-Regular ",
       "-annotate -11x5-1000-1700 'Population Density' ",
       "-background none +repage ",
       
       # "-fill '{colors[2]}' -stroke '{colors[2]}' -strokewidth 5 ",
       # "-annotate -3x0-1150+700 'Population Density' ",
       # "-gravity north -annotate +0+1000 'Population' ", 
       # "-gravity northeast -kerning 200 -annotate +500+200 'Density' ",
       "images/connecticut/titled_ct_pop_one.png +swap ",
       "-composite images/connecticut/titled_ct_pop_done.png")
)

cap <- glue("Graphic: Spencer Schien (@MrPecners) | ",
     "Kontur Population Data (Released June 30, 2022)")

system(
  glue("convert -size 8000x6000 xc:none -gravity Center ",
       
       "-stroke '{alpha(colors[3], .5)}' -fill '{alpha(colors[3], .5)}' ",
       "-pointsize 50 -kerning 20 -font Amarante-Regular ",
       "-annotate -15x5+1500+1200 '{cap}' ",
       "-background none +repage ",
       
       # "-fill '{colors[2]}' -stroke '{colors[2]}' -strokewidth 5 ",
       # "-annotate -3x0-1150+700 'Population Density' ",
       # "-gravity north -annotate +0+1000 'Population' ", 
       # "-gravity northeast -kerning 200 -annotate +500+200 'Density' ",
       "images/connecticut/titled_ct_pop_done.png +swap ",
       "-composite images/connecticut/titled_ct_pop_cap.png")
)



image_read("images/connecticut/titled_ct_pop_done.png") |> 
  image_scale(geometry = "53%x") |> 
  image_write("tracked_graphics/titled_ct_pop_small.png")

