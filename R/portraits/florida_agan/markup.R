library(tidyverse)
library(magick)
library(glue)
library(colorspace)

# Load `header` list with needed data
header <- readRDS("R/portraits/florida_agan/header.rds")
colors <- header$colors
swatchplot(colors)

text_color <- colors[1] |> 
  darken(.35)

img <- image_read(header$outfile)


annot <- glue("This map shows population density of ",
              "{str_to_title('florida_agan')}. ",
              "Population estimates are bucketed ",
              "into 400 meter (about 1/4 mile) hexagons.") |> 
  str_wrap(45)
cat(annot)



img |> 
  image_crop(geometry = "6500x6200+300+300", gravity = "center") |> 
  image_annotate(text = "FLORIDA", 
                 gravity = "center",
                 location = "-1250-700", font = "Limelight",
                 color = text_color,
                 size = 500, kerning = 100, weight = 700) |> 
  # image_annotate(text = "Population Density",
  #                gravity = "center",
  #                location = "-1250-300", font = "Rock Salt",
  #                size = 200, color = colors[8], degrees = -10, 
  #                decoration = "underline") |> 
  image_annotate(text = glue("Graphic: Spencer Schien (@MrPecners) | ",
                             "Kontur Population Data (Released June 30, 2022)"),
                 gravity = "south",
                 location = "+0+100", font = "Rock Salt",
                 color = alpha(text_color, .5),
                 kerning = 20,
                 size = 60, weight = 700) |> 
  image_write("images/florida_agan/titled_fl_pop.png")

system(
  glue("convert -size 6500x6200 xc:none -gravity Center ",

       
       "-stroke black -fill black ",
       "-pointsize 225 -font Rock-Salt-Regular ",
       "-annotate -2x0-1150-300 'Population Density' ",
       "-background none -blur 250x50 +repage ",
       
       "-stroke '{colors[8]}' -fill white -strokewidth 10 ",
       "-annotate -2x0-1150-300 'Population Density' ",
       "-distort arc 30 ",
       # "-gravity north -annotate +0+1000 'Population' ", 
       # "-gravity northeast -kerning 200 -annotate +500+200 'Density' ",
       "images/florida_agan/titled_fl_pop.png +swap ",
       "-composite images/florida_agan/titled_fl_pop_done.png")
)


image_read("images/florida_agan/titled_fl_pop_done.png") |> 
  image_scale(geometry = "53%x") |> 
  image_write("tracked_graphics/titled_fl_pop_small.png")

