library(tidyverse)
library(magick)
library(glue)
library(colorspace)
library(scico)

# Load `header` list with needed data
header <- readRDS("R/portraits/oklahoma/header.rds")
c1 <- scico(n = 10, palette = "lajolla", direction = -1)
colors <- c1
swatchplot(colors)

text_color <- c1[4]


img <- image_read(header$outfile)



img |> 
  image_crop(geometry = "10000x6000+0-500", gravity = "center") |> 
  image_annotate(text = glue("Graphic: Spencer Schien (@MrPecners) | ",
                             "Kontur Population Data (Released June 30, 2022)"),
                 gravity = "south",
                 location = "+0+100", font = "Alegreya",
                 color = alpha(text_color, .75),
                 kerning = 20,
                 size = 65, weight = 700) |> 
  image_write("images/oklahoma/titled_ok_pop.png")


system(
  glue("convert -size 10000x6000 xc:none ",
       # Shadows
       "-gravity northwest -font Alegreya-Sans-SC-ExtraBold ",
       "-pointsize 400 -kerning 100 -stroke '{colors[2]}' -fill '{colors[2]}' ",
       "-annotate +480+190 'Oklahoma' ",
       "-background none ",
       "-gravity north -kerning 100 -annotate -20+590 'Population' ",
       "-background none ",
       "-gravity northeast -kerning 200 -annotate +520+990 'Density' ",
       "-background none -blur 50x30 +repage ",
       
       # Foreground font
       "-gravity northwest ",
       "-stroke '{colors[9]}' -fill '{colors[7]}' ",
       "-gravity northwest -kerning 100 -annotate +500+200 'Oklahoma' ", 
       "-gravity north -kerning 100 -annotate +0+600 'Population' ", 
       "-gravity northeast -kerning 200 -annotate +500+1000 'Density' ",
       "images/oklahoma/titled_ok_pop.png +swap ",
       "-composite images/oklahoma/titled_ok_pop_done.png")
)

image_read("images/oklahoma/titled_ok_pop_done.png") |> 
  image_scale(geometry = "44%x") |> 
  image_write("tracked_graphics/titled_ok_pop_small.png")

