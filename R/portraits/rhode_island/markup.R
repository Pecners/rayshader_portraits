library(tidyverse)
library(magick)
library(glue)
library(colorspace)

# Load `header` list with needed data
header <- readRDS("R/portraits/rhode_island/header.rds")
colors <- header$colors
swatchplot(colors)

text_color <- colors[4]

img <- image_read(header$outfile)
image_info(img)

# annot <- glue("This map shows population density of ",
#               "{str_to_title('rhode_island')}. ",
#               "Population estimates are bucketed ",
#               "into 400 meter (about 1/4 mile) hexagons.") |> 
#   str_wrap(45)
# cat(annot)


img |> 
  # crop the image to desired dimensions
  image_crop(geometry = "8000x8000+0-500", gravity = "center") |> 
  image_write("images/rhode_island/titled_ri_pop.png")

# Use system() to make imagemagick calls manually
# This code chunk adds the "rhode_islan" title

system(
  glue("convert -size 8000X8000 xc:none -gravity Center ",
       
       "-stroke '{text_color}' -fill '{text_color}' ",
       "-pointsize 400 -kerning 100 -font Poller-One ",
       "-strokewidth 10 -annotate -10.2x5-1000-3000 'RHODE ISLAND' ",
       " -background none ",
       # "-gravity north -annotate +0+1000 'Population' ", 
       # "-gravity northeast -kerning 200 -annotate +500+200 'Density' ",
       "images/rhode_island/titled_ri_pop.png +swap ",
       "-composite images/rhode_island/titled_ri_pop_one.png")
)

system(
  glue("convert -size 8000x8000 xc:none -gravity Center ",
       
       "-stroke '{lighten(colors[4], .15)}' -fill '{lighten(colors[4], .15)}' ",
       "-pointsize 400 -kerning 100 -font Amarante-Regular ",
       "-annotate -12x5+0-2500 'Population Density' ",
       "-background none +repage ",
       
       # "-fill '{colors[2]}' -stroke '{colors[2]}' -strokewidth 5 ",
       # "-annotate -3x0-1150+700 'Population Density' ",
       # "-gravity north -annotate +0+1000 'Population' ", 
       # "-gravity northeast -kerning 200 -annotate +500+200 'Density' ",
       "images/rhode_island/titled_ri_pop_one.png +swap ",
       "-composite images/rhode_island/titled_ri_pop_done.png")
)


cap <- glue("Graphic: Spencer Schien (@MrPecners) | ",
            "Kontur Population Data (Released June 30, 2022)")

system(
  glue("convert -size 8000x6000 xc:none -gravity Center ",
       
       "-stroke '{lighten(colors[4], .1)}' -fill '{lighten(colors[4], .1)}' ",
       "-pointsize 60 -kerning 20 -font Amarante-Regular ",
       "-annotate -12x5+275-2340 '{cap}' ",
       "-background none +repage ",
       
       # "-fill '{colors[2]}' -stroke '{colors[2]}' -strokewidth 5 ",
       # "-annotate -3x0-1150+700 'Population Density' ",
       # "-gravity north -annotate +0+1000 'Population' ", 
       # "-gravity northeast -kerning 200 -annotate +500+200 'Density' ",
       "images/rhode_island/titled_ri_pop_done.png +swap ",
       "-composite images/rhode_island/titled_ri_pop_cap.png")
)



image_read("images/rhode_island/titled_ri_pop_cap.png") |> 
  image_scale(geometry = "48%x") |> 
  image_write("tracked_graphics/titled_ri_pop_small.png")

