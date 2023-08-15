library(tidyverse)
library(magick)
library(glue)
library(colorspace)

# Load `header` list with needed data
header <- readRDS("R/portraits/new_hampshire/header.rds")
colors <- header$colors
swatchplot(colors)

text_color <- colors[4]

img <- image_read(header$outfile)


# annot <- glue("This map shows population density of ",
#               "{str_to_title('new_hampshire')}. ",
#               "Population estimates are bucketed ",
#               "into 400 meter (about 1/4 mile) hexagons.") |> 
#   str_wrap(45)
# cat(annot)



img |> 
  # crop the image to desired dimensions
  image_crop(geometry = "7000x7000-400+300", gravity = "center") |> 
  image_annotate(text = glue("Graphic: Spencer Schien (@MrPecners) | ",
                             "Kontur Population Data (Released June 30, 2022)"),
                 gravity = "southeast",
                 location = "+300+300", font = "Kaushan Script",
                 color = alpha(text_color, .5),
                 kerning = 20,
                 size = 70, weight = 700) |> 
  image_write("images/new_hampshire/titled_nh_pop.png")

# Use system() to make imagemagick calls manually
# This code chunk adds the "new_hampshire" title
system(
  glue("convert -size 7000x7000 xc:none -gravity northwest ",
       
       "-stroke '{colors[4]}' -fill '{colors[4]}' -strokewidth 0 ",
       "-pointsize 350 -kerning 100 -font Knewave ",
       "-annotate -3x0+1400+1750 'NEW HAMPSHIRE' ",
       "-distort arc 45 -background none ",
       # "-gravity north -annotate +0+1000 'Population' ", 
       # "-gravity northeast -kerning 200 -annotate +500+200 'Density' ",
       "-rotate -8 images/new_hampshire/titled_nh_pop.png +swap ",
       "-gravity south -geometry +0+0 ",
       "-composite images/new_hampshire/titled_nh_pop_one.png")
)

# This code chunk adds "Population Density"

system(
  glue("convert -size 7000x7000 xc:none -gravity northwest ",
       "-pointsize 350 -kerning 50 -font Kaushan-Script ",
       "-fill '{lighten(colors[4], .25)}' -stroke '{lighten(colors[4], .25)}' -strokewidth 5 ",
       "-annotate -3x0+1100+2300 'Population Density' ",
       "-distort arc 45 -background none ",
       # "-gravity north -annotate +0+1000 'Population' ", 
       # "-gravity northeast -kerning 200 -annotate +500+200 'Density' ",
       "-rotate -9 images/new_hampshire/titled_nh_pop_one.png +swap ",
       "-gravity south -geometry +0+0 ",
       "-composite images/new_hampshire/titled_nh_pop_done.png")
)


image_read("images/new_hampshire/titled_nh_pop_done.png") |> 
  image_scale(geometry = "49%x") |> 
  image_write("tracked_graphics/titled_nh_pop_small.png")

