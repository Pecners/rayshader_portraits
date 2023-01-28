library(tidyverse)
library(magick)
library(glue)

# Load `header` list with needed data
header <- readRDS("R/portraits/phi_sf/header.rds")
colors <- header$colors
swatchplot(colors)

text_color <- colors[5]

img <- image_read(header$outfile)


annot <- glue("This map shows population density of ",
              "{str_to_title('phi_sf')}. ",
              "Population estimates are bucketed ",
              "into 400 meter (about 1/4 mile) hexagons.") |> 
  str_wrap(45)
cat(annot)



img |> 
  image_crop(geometry = "8000x6000+0+350", gravity = "center") |> 
  image_annotate(text = "Philadelphia",
                 gravity = "north",
                 location = "+2250+2900",
                 font = "El Messiri",
                 color = text_color,
                 size = 350) |>
  image_annotate(text = "San Francisco",
                 gravity = "north",
                 location = "+500+4500", 
                 font = "El Messiri",
                 color = text_color,
                 size = 350) |>
  image_annotate(text = glue("Graphic: Spencer Schien (@MrPecners) | ",
                             "Kontur Population Data (Released June 30, 2022)"),
                 gravity = "southeast",
                 location = "+200+100", font = "El Messiri",
                 color = alpha(text_color, .5),
                 size = 80, weight = 700) |> 
  image_write("images/phi_sf/titled_phi_sf_pop.png")

# Add title

system(
  glue(
    "convert images/phi_sf/titled_phi_sf_pop.png ",
    "-gravity north -font El-Messiri-Bold -pointsize 350 ", 
    "-fill '{alpha(colors[5], .5)}' -stroke '{colors[5]}' -strokewidth 5 ", 
    "-draw 'roundrectangle 250,550 2750,2150 10,10' ", 
    "-stroke '{colors[5]}' -strokewidth 5 -fill '{colors[9]}' ",
    "-annotate -2500+500 'COMPARATIVE' ",
    "-kerning 25 -annotate -2500+1100 'POPULATION' ",
    "-kerning 150 -annotate -2500+1700 'DENSITY' ",
    "images/phi_sf/titled_phi_sf_pop_.png"
    )
)



image_read("images/phi_sf/titled_phi_sf_pop_.png") |> 
  image_scale(geometry = "50%x") |> 
  image_write("tracked_graphics/titled_phi_sf_pop_small.png")

