library(tidyverse)
library(magick)
library(glue)
library(colorspace)

# Load `header` list with needed data
header <- readRDS("R/portraits/west_virginia/header.rds")
colors <- header$colors
swatchplot(colors)

text_color <- colors[1]

img <- image_read(header$outfile)
image_info(img)

img |> 
  image_crop(geometry = "7500x5625-300+0", gravity = "center") |> 
  image_annotate(text = glue("Graphic by Spencer Schien (@MrPecners) | ",
                             "Kontur Population Data (Released June 30, 2022)"),
                 gravity = "south",
                 location = "+0+250", 
                 font = "Cinzel Decorative",
                 color = colors[7],
                 size = 50,
                 kerning = 40) |> 
  image_write("images/west_virginia/titled_wv_pop.png")

system(
  glue("convert -size 10000x10000 xc:none ",
       # Shadows
       "-gravity north -font Cinzel-Decorative-Bold ",
       "-pointsize 400 -kerning 200 -stroke '{colors[4]}' -fill '{colors[4]}' ", 
       "-annotate -20+685 'West Virginia' ",
       "-background none -blur 50x15 +repage ",
       "-pointsize 200 -kerning 150 -stroke '{colors[4]}' -fill '{colors[4]}' ", 
       "-annotate -1470+1490 'Population' ",
       "-annotate +1880+1490 'Density' ",
       "-background none -blur 30x10 +repage ",
       # Foreground font
       "-font Cinzel-Decorative-Bold ",
       "-stroke '{colors[4]}' -strokewidth 5 -fill '{colors[7]}' ",
       "-pointsize 400 -kerning 200 -annotate +0+700 'West Virginia' ", 
       "-stroke '{colors[4]}' -fill '{colors[7]}' ",
       "-pointsize 200 -kerning 150 -strokewidth 2  ",
       "-annotate -1450+1500 'Population' ", 
       "-annotate +1900+1500 'Density' ", 
       "images/west_virginia/titled_wv_pop.png +swap -gravity north ",
       "-composite images/west_virginia/titled_wv_pop_done.png")
)

image_read("images/west_virginia/titled_wv_pop_done.png") |> 
  image_scale(geometry = "54%x") |> 
  image_write("tracked_graphics/titled_wv_pop_small.png")

