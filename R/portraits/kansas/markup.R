library(tidyverse)
library(magick)
library(glue)
library(colorspace)

# Load `header` list with needed data
header <- readRDS("R/portraits/kansas_again/header.rds")
colors <- header$colors
swatchplot(colors)

text_color <- colors[1] 

img <- image_read(header$outfile)

cap <- glue("Graphic: Spencer Schien (@MrPecners) | ",
            "Kontur Population Data (Released June 30, 2022)")

img |> 
  image_crop(geometry = "10000x6666+0+0", gravity = "center") |> 
  image_annotate(text = "KANSAS", 
                 gravity = "north",
                 location = "+400+400", font = "Poller One",
                 color = colors[1],
                 size = 800, kerning = 300, weight = 700) |> 
  image_annotate(text = "Population Density", 
                 gravity = "north",
                 location = "+1400+1400", font = "Amarante",
                 color = colors[2],
                 size = 400, kerning = 100) |> 
  # image_annotate(text = "Population Density",
  #                gravity = "center",
  #                location = "-1250-300", font = "Rock Salt",
  #                size = 200, color = colors[8], degrees = -10, 
  #                decoration = "underline") |> 
  # image_annotate(text = glue("Graphic: Spencer Schien (@MrPecners) | ",
  #                            "Kontur Population Data (Released June 30, 2022)"),
  #                gravity = "south",
  #                location = "+0+100", font = "Rock Salt",
  #                color = alpha("white", .5),
  #                kerning = 20,
  #                size = 60, weight = 700) |> 
  image_write("images/kansas_again/titled_kansas_pop.png")



system(
  glue("convert -size 10000x6000 xc:none -gravity center ",
       "-stroke '{alpha(text_color, .5)}' -fill '{alpha(text_color, .5)}' ",
       "-pointsize 60 -kerning 25 -font Amarante-Regular ",
       "-annotate 5.75x5-500+1550 '{cap}' ",
       "-background none +repage ",
       "-rotate 180 -distort arc '2 180' ",
       
       # "-fill '{colors[2]}' -stroke '{colors[2]}' -strokewidth 5 ",
       # "-annotate -3x0-1150+700 'Population Density' ",
       # "-gravity north -annotate +0+1000 'Population' ", 
       # "-gravity northeast -kerning 200 -annotate +500+200 'Density' ",
       "images/kansas_again/titled_kansas_pop.png +swap ",
       "-composite images/kansas_again/titled_kansas_pop_done_cap.png")
)

image_read("images/kansas_again/titled_kansas_pop_done_cap.png") |> 
  image_scale(geometry = "43%x") |> 
  image_write("tracked_graphics/titled_kansas_again_pop_small.png")

# # east
# image_read("images/kansas/titled_kansas_again_pop_done.png") |> 
#   image_crop(gravity = "center", geometry = "3000x2000+3000-1000") |> 
#   image_write("images/kansas/titled_nc_east.png")
# 
# # central
# image_read("images/kansas/titled_kansas_pop_done.png") |> 
#   image_crop(gravity = "center", geometry = "3000x2000") |> 
#   # image_annotate(gravity = "center", text = "Charlotte",
#   #                location = "-300+100", 
#   #                color = colors[8],
#   #                font = "Rock Salt", size = 100) |> 
#   image_write("images/kansas/titled_nc_central.png")
# 
# image_read("images/kansas/titled_kansas_pop_done.png") |> 
#   image_crop(gravity = "west", geometry = "3000x2000+200+700") |> 
#   image_write("images/kansas/titled_nc_west.png")