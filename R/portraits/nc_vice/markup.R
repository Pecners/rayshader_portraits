library(tidyverse)
library(magick)
library(glue)
library(colorspace)

# Load `header` list with needed data
header <- readRDS("R/portraits/nc_vice/header.rds")
colors <- header$colors
swatchplot(colors)

text_color <- colors[1] |> 
  darken(.35)

img <- image_read(header$outfile)


img |> 
  image_crop(geometry = "9000x6750+0+0", gravity = "center") |> 
  image_annotate(text = "NORTH CAROLINA", 
                 gravity = "north",
                 location = "-1250+500", font = "Limelight",
                 color = "white",
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
                 color = alpha(colors[8], .5),
                 kerning = 20,
                 size = 60, weight = 700) |> 
  image_write("images/nc_vice/titled_nc_vice_pop.png")

system(
  glue("convert -size 7000x6200 xc:none -gravity north ",
       "-stroke black -fill black ",
       "-pointsize 350 -font Rock-Salt-Regular ",
       "-annotate -5x0-900+700 'Population Density' ",
       "-background none -blur 250x50 +repage ",
       
       "-stroke '{colors[8]}' -fill white -strokewidth 10 ",
       "-annotate -5x0-900+700 'Population Density' ",
       "-distort arc 45 ",
       # "-gravity north -annotate +0+1000 'Population' ", 
       # "-gravity northeast -kerning 200 -annotate +500+200 'Density' ",
       "images/nc_vice/titled_nc_vice_pop.png +swap ",
       "-composite images/nc_vice/titled_nc_vice_pop_done.png")
)


image_read("images/nc_vice/titled_nc_vice_pop_done.png") |> 
  image_scale(geometry = "41%x") |> 
  image_write("tracked_graphics/titled_nc_vice_pop_small.png")
