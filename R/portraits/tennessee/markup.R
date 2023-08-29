library(tidyverse)
library(magick)
library(glue)
library(colorspace)

# Load `header` list with needed data
header <- readRDS("R/portraits/tennessee/header.rds")
colors <- header$colors
swatchplot(colors)

text_color <- colors[1]

img <- image_read(header$outfile)
image_info(img)

# annot <- glue("This map shows population density of ",
#               "{str_to_title('tennessee')}. ",
#               "Population estimates are bucketed ",
#               "into 400 meter (about 1/4 mile) hexagons.") |> 
#   str_wrap(45)
# cat(annot)



img |> 
  # crop the image to desired dimensions
  image_crop(geometry = "14000X9333+0-250", gravity = "center") |> 
  image_write("images/tennessee/titled_tn_pop.png")

# Use system() to make imagemagick calls manually
# This code chunk adds the "tennessee" title
system(
  glue("convert -size 14000X9333 xc:none -gravity Center ",
       
       "-stroke '{text_color}' -fill '{text_color}' ",
       "-pointsize 750 -kerning 100 -font Poller-One ",
       "-strokewidth 10 -annotate -15x5-2000-2800 'TENNESSEE' ",
       "-rotate 180 -distort Arc '10 180' -background none ",
       # "-gravity north -annotate +0+1000 'Population' ", 
       # "-gravity northeast -kerning 200 -annotate +500+200 'Density' ",
       "images/tennessee/titled_tn_pop.png +swap ",
       "-composite images/tennessee/titled_tn_pop_one.png")
)

system(
  glue("convert -size 14000X9333 xc:none -gravity Center ",
       
       
       "-stroke '{colors[3]}' -fill '{colors[3]}' ",
       "-pointsize 750 -kerning 100 -font Amarante-Regular ",
       "-annotate -15.5x5-750-2200 'Population Density' ",
       "-rotate 180 -distort Arc '5 180' -background none +repage ",
       
       # "-fill '{colors[2]}' -stroke '{colors[2]}' -strokewidth 5 ",
       # "-annotate -3x0-1150+700 'Population Density' ",
       # "-gravity north -annotate +0+1000 'Population' ", 
       # "-gravity northeast -kerning 200 -annotate +500+200 'Density' ",
       "images/tennessee/titled_tn_pop_one.png +swap ",
       "-composite images/tennessee/titled_tn_pop_done.png")
)

cap <- glue("Graphic: Spencer Schien (@MrPecners) | ",
            "Kontur Population Data (Released June 30, 2022)")

system(
  glue("convert -size 14000X9333 xc:none -gravity Center ",
       
       "-stroke '{alpha(colors[3], .5)}' -fill '{alpha(colors[3], .5)}' ",
       "-pointsize 115 -kerning 20 -font Amarante-Regular ",
       "-annotate -15.5x5-325-1900 '{cap}' ",
       "-rotate 180 -distort Arc '5 180' -background none +repage ",
       
       # "-fill '{colors[2]}' -stroke '{colors[2]}' -strokewidth 5 ",
       # "-annotate -3x0-1150+700 'Population Density' ",
       # "-gravity north -annotate +0+1000 'Population' ", 
       # "-gravity northeast -kerning 200 -annotate +500+200 'Density' ",
       "images/tennessee/titled_tn_pop_done.png +swap ",
       "-composite images/tennessee/titled_tn_pop_cap.png")
)


image_read("images/tennessee/titled_tn_pop_cap.png") |> 
  image_scale(geometry = "34%x") |> 
  image_write("tracked_graphics/titled_tn_pop_small.png")
