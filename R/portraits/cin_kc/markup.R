library(tidyverse)
library(magick)
library(glue)

# Load `header` list with needed data
header <- readRDS("R/portraits/cin_kc/header.rds")
colors <- header$colors
swatchplot(colors)

text_color <- colors[4]

img <- image_read(header$outfile)



img |> 
  image_crop(geometry = "7250x6000+0+0", gravity = "center") |> 
  image_annotate(text = "Cincinnati",
                 gravity = "north",
                 location = "+2250+2900",
                 font = "El Messiri",
                 color = text_color,
                 size = 350) |>
  image_annotate(text = "CENSUS METRO AREA",
                 gravity = "north",
                 location = "+2250+3350",
                 kerning = 13,
                 font = "El Messiri",
                 color = text_color,
                 size = 125) |>
  image_annotate(text = "Kansas City",
                 gravity = "north",
                 location = "+750+4800", 
                 font = "El Messiri",
                 color = text_color,
                 size = 350) |>
  image_annotate(text = "CENSUS METRO AREA",
                 gravity = "north",
                 location = "+750+5250",
                 font = "El Messiri",
                 kerning = 30,
                 color = text_color,
                 size = 125) |>
  image_annotate(text = glue("Graphic: Spencer Schien (@MrPecners) | ",
                             "Kontur Population Data (Released June 30, 2022)"),
                 gravity = "southeast",
                 location = "+200+100", font = "El Messiri",
                 color = alpha(text_color, .5),
                 size = 80, weight = 700) |> 
  image_write("images/cin_kc/titled_cin_kc_pop.png")

# Add title

system(
  glue(
    "convert images/cin_kc/titled_cin_kc_pop.png ",
    "-gravity north -font El-Messiri-Bold -pointsize 350 ", 
    "-fill '{alpha(colors[4], .25)}' -stroke '{colors[4]}' -strokewidth 2 ",
    "-draw 'roundrectangle 550,325 3100,1775 10,10' ",
    "-stroke '{colors[4]}' -strokewidth 2 -fill '{colors[5]}' ",
    "-annotate -1800+300 'COMPARATIVE' ",
    "-kerning 25 -annotate -1800+800 'POPULATION' ",
    "-kerning 150 -annotate -1800+1300 'DENSITY' ",
    "images/cin_kc/titled_cin_kc_pop_.png"
  )
)


image_read("images/cin_kc/titled_cin_kc_pop_.png") |> 
  image_scale(geometry = "49%x") |> 
  image_write("tracked_graphics/titled_cin_kc_pop_small.png")

