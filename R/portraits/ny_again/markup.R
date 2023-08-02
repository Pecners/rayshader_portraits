library(tidyverse)
library(magick)
library(glue)
library(colorspace)

# Load `header` list with needed data
header <- readRDS("R/portraits/ny_again/header.rds")
colors <- header$colors
swatchplot(colors)

text_color <- colors[1] |> 
  darken(.35)

img <- image_read(header$outfile)

cap <- glue("Graphic: Spencer Schien (@MrPecners) | ",
            "Kontur Population Data (Released June 30, 2022)")

img |> 
  image_crop(geometry = "8000x5333+300+400", gravity = "center") |> 
  image_annotate(text = "NEW YORK", 
                 gravity = "north",
                 location = "-1250+500", font = "Limelight",
                 color = "white",
                 size = 600, kerning = 100, weight = 700) |> 
  # image_annotate(text = "Population Density",
  #                gravity = "center",
  #                location = "-1250-300", font = "Rock Salt",
  #                size = 200, color = colors[8], degrees = -10, 
  #                decoration = "underline") |> 
  # image_annotate(text = glue("Graphic: Spencer Schien (@MrPecners) | ",
  #                            "Kontur Population Data (Released June 30, 2022)"),
  #                gravity = "south", degrees = -12,
  #                location = "-800+1000", font = "Rock Salt", 
  #                color = alpha(colors[5], .5),
  #                size = 40, weight = 700) |> 
  image_write("images/ny_again/titled_ny_again_pop.png")


system(
  glue("convert -size 7000x6200 xc:none -gravity north ",
       "-stroke black -fill black ",
       "-pointsize 250 -font Rock-Salt-Regular ",
       "-annotate -5x0-900+700 'Population Density' ",
       "-background none -blur 250x50 +repage ",
       
       "-stroke '{colors[8]}' -fill white -strokewidth 10 ",
       "-annotate -5x0-900+700 'Population Density' ",
       "-distort arc 45 ",
       # "-gravity north -annotate +0+1000 'Population' ", 
       # "-gravity northeast -kerning 200 -annotate +500+200 'Density' ",
       "images/ny_again/titled_ny_again_pop.png +swap ",
       "-composite images/ny_again/titled_ny_again_pop_done.png")
)

# Caption
system(
  glue("convert -size 9500x6333 xc:none -gravity south ",
       
       
       "-stroke '{alpha(colors[5], .5)}' -fill '{alpha(colors[5], .5)}' ",
       "-pointsize 40 -kerning 10 -font Rock-Salt-Regular ",
       "-annotate -11.85x5-1200+950 '{cap}' ",
       "-background none +repage ",
       # "-rotate 180 -distort arc '8 180' ",
       
       # "-fill '{colors[2]}' -stroke '{colors[2]}' -strokewidth 5 ",
       # "-annotate -3x0-1150+700 'Population Density' ",
       # "-gravity north -annotate +0+1000 'Population' ", 
       # "-gravity northeast -kerning 200 -annotate +500+200 'Density' ",
       "images/ny_again/titled_ny_again_pop_done.png +swap ",
       "-composite images/ny_again/titled_ny_again_pop_done_cap.png")
)


image_read("images/ny_again/titled_ny_again_pop_done_cap.png") |> 
  image_scale(geometry = "50%x") |> 
  image_write("tracked_graphics/titled_ny_again_pop_small.png")

