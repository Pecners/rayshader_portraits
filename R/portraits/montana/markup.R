library(tidyverse)
library(magick)
library(glue)
library(colorspace)

# Load `header` list with needed data
header <- readRDS("R/portraits/montana/header.rds")
colors <- header$colors
swatchplot(colors)

text_color <- colors[2]

img <- image_read(header$outfile)
cap <- glue("Graphic: Spencer Schien (@MrPecners) | ",
            "Kontur Population Data (Released June 30, 2022)")


img |> 
  image_crop(geometry = "9500x6333+0+0", gravity = "center") |> 
  # image_annotate(text = "massachusetts", 
  #                gravity = "center",
  #                location = "-1500-500", font = "Knewave",
  #                color = text_color,
  #                size = 600, kerning = 150, weight = 700) |> 
  # image_annotate(text = "Population Density",
  #                gravity = "center",
  #                location = "-1250-300", font = "Rock Salt",
  #                size = 200, color = colors[8], degrees = -10, 
  #                decoration = "underline") |> 
  # image_annotate(text = glue("Graphic: Spencer Schien (@MrPecners) | ",
  #                            "Kontur Population Data (Released June 30, 2022)"),
  #                gravity = "south",
  #                location = "+0+100", font = "Amarante",
  #                color = alpha(text_color, .5),
  #                kerning = 20,
  #                size = 60, weight = 700) |> 
  image_write("images/montana/titled_mt_pop.png")

system(
  glue("convert -size 9500x6333 xc:none -gravity North ",
       
       "-stroke '{'white'}' -fill '{'white'}' ",
       "-pointsize 500 -kerning 200 -font Academy-Engraved-LET-Plain:1.0 ",
       "-annotate -10.6x5-500+1250 'MONTANA' -background none ",
       "-rotate 180 -distort arc '9 180' ",
       # "-gravity north -annotate +0+1000 'Population' ", 
       # "-gravity northeast -kerning 200 -annotate +500+200 'Density' ",
       "images/montana/titled_mt_pop.png +swap ",
       "-gravity south -geometry -1750+150 ",
       "-composite images/montana/titled_mt_pop_one.png")
)

system(
  glue("convert -size 9500x6333 xc:none -gravity North ",
       
       
       "-stroke '{text_color}' -fill '{text_color}' ",
       "-pointsize 300 -kerning 150 -font Cormorant-SC-Bold ",
       "-annotate -11.9x5-500+1250 'Population Density' ",
       "-background none +repage ",
       "-rotate 180 -distort arc '7 180' ",
       
       # "-fill '{colors[2]}' -stroke '{colors[2]}' -strokewidth 5 ",
       # "-annotate -3x0-1150+700 'Population Density' ",
       # "-gravity north -annotate +0+1000 'Population' ", 
       # "-gravity northeast -kerning 200 -annotate +500+200 'Density' ",
       "images/montana/titled_mt_pop_one.png +swap ",
       # "-gravity south -geometry +0-700 ",
       "-composite images/montana/titled_mt_pop_done.png")
)

system(
  glue("convert -size 9500x6333 xc:none -gravity North ",
       
       
       "-stroke '{alpha(text_color, .5)}' -fill '{alpha(text_color, .5)}' ",
       "-pointsize 60 -kerning 20 -font Cormorant-SC-Bold ",
       "-annotate -11x5+2000+3800 '{cap}' ",
       "-background none +repage ",
       "-rotate 180 -distort arc '8 180' ",
       
       # "-fill '{colors[2]}' -stroke '{colors[2]}' -strokewidth 5 ",
       # "-annotate -3x0-1150+700 'Population Density' ",
       # "-gravity north -annotate +0+1000 'Population' ", 
       # "-gravity northeast -kerning 200 -annotate +500+200 'Density' ",
       "images/montana/titled_mt_pop_done.png +swap ",
       "-composite images/montana/titled_mt_pop_done_cap.png")
)



image_read("images/montana/titled_mt_pop_done_cap.png") |> 
  image_scale(geometry = "49%x") |> 
  image_write("tracked_graphics/titled_mt_pop_small.png")
