library(tidyverse)
library(magick)
library(glue)
library(colorspace)

# Load `header` list with needed data
header <- readRDS("R/portraits/vermont/header.rds")
colors <- header$colors
swatchplot(colors)

text_color <- colors[8]

img <- image_read(header$outfile)
image_info(img)

# annot <- glue("This map shows population density of ",
#               "{str_to_title('vermont')}. ",
#               "Population estimates are bucketed ",
#               "into 400 meter (about 1/4 mile) hexagons.") |> 
#   str_wrap(45)
# cat(annot)



img |> 
  # crop the image to desired dimensions
  image_crop(geometry = "9500x7600+250+0", gravity = "center") |> 
  image_annotate(text = glue("Graphic: Spencer Schien (@MrPecners) | ",
                             "Kontur Population Data (Released June 30, 2022)"),
                 gravity = "southeast",
                 location = "+300+350", font = "Kaushan Script",
                 color = alpha(text_color, .5),
                 kerning = 20,
                 size = 70, weight = 700) |> 
  image_write("images/vermont/titled_vt_pop.png")

# Use system() to make imagemagick calls manually
# This code chunk adds the "VERMONT" title
system(
  glue("convert -size 7000x7000 xc:none -gravity west ",
       
       "-stroke '{colors[7]}' -fill '{colors[7]}' -strokewidth 0 ",
       "-pointsize 500 -kerning 200 -font Knewave ",
       "-annotate -3x0+1750+0 'VERMONT' ",
       "-distort arc 45 -background none ",
       # "-gravity north -annotate +0+1000 'Population' ", 
       # "-gravity northeast -kerning 200 -annotate +500+200 'Density' ",
       "-rotate -12 +repage images/vermont/titled_vt_pop.png +swap ",
       "-gravity south -geometry +2200-1500 ",
       "-composite images/vermont/titled_vt_pop_one.png")
)

# This code chunk adds "Population Density"

system(
  glue("convert -size 7000x7000 xc:none -gravity west ",
       "-pointsize 450 -font Kaushan-Script ",
       "-fill '{colors[8]}' -stroke '{colors[8]}' -strokewidth 5 ",
       "-annotate -3x0+1500+700 'Population Density' ",
       "-distort arc 45 -background none ",
       # "-gravity north -annotate +0+1000 'Population' ", 
       # "-gravity northeast -kerning 200 -annotate +500+200 'Density' ",
       "-rotate -12 +repage images/vermont/titled_vt_pop_one.png +swap ",
       "-gravity south -geometry +2200-1500 ",
       "-composite images/vermont/titled_vt_pop_done.png")
)

img2 <- image_read("images/vermont/titled_vt_pop_done.png")
image_info(img2)

image_read("images/vermont/titled_vt_pop_done.png") |> 
  image_scale(geometry = "44%x") |> 
  image_write("tracked_graphics/titled_vt_pop_small.png")

