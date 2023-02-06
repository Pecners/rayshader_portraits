library(tidyverse)
library(magick)
library(glue)
library(colorspace)

# Load `header` list with needed data
header <- readRDS("R/portraits/iowa/header.rds")
colors <- header$colors
swatchplot(colors)

text_color <- colors[5]

img <- image_read(header$outfile)


annot <- glue("This map shows population density of ",
              "{str_to_title('iowa')}. ",
              "Population estimates are bucketed ",
              "into 400 meter (about 1/4 mile) hexagons.") |> 
  str_wrap(45)
cat(annot)



img |> 
  image_crop(geometry = "x6250+0-400", gravity = "center") |>
  # image_annotate(text = "Population Density", 
  #                gravity = "north",
  #                location = "+2000+1500", 
  #                font = "Cinzel Decorative",
  #                color = text_color,
  #                size = 225, weight = 700) |> 
  # image_annotate(text = annot, gravity = "northeast",
  #                location = "+200+500", font = "El Messiri",
  #                color = alpha(text_color, .75),
  #                size = 115) |> 
image_annotate(text = glue("Graphic by Spencer Schien (@MrPecners) | ",
                           "Kontur Population Data (Released June 30, 2022)"),
               gravity = "south",
               location = "+0+100", 
               font = "Cinzel Decorative",
               color = alpha(text_color, .5),
               size = 80,
               kerning = 20) |> 
  image_write("images/iowa/titled_ia_pop.png")

system(
  glue("convert -size 9000x6250 xc:none ",
       # Shadows
       "-gravity north -font Cinzel-Decorative-Bold ",
       "-pointsize 900 -kerning 200 -stroke '{colors[5]}' -fill '{colors[5]}' ", 
       "-annotate +1880+185 'Iowa' ",
       "-background none -blur 50x15 +repage ",
       "-pointsize 250 -kerning 25 -stroke '{colors[5]}' -fill '{colors[5]}' ", 
       "-annotate +1895+1290 'Population Density' ",
       "-background none -blur 30x5 +repage ",
       # Foreground font
       "-font Cinzel-Decorative-Bold ",
       "-stroke '{colors[5]}' -strokewidth 5 -fill '{colors[8]}' ",
       "-pointsize 900 -kerning 200 -annotate +1900+200 'Iowa' ", 
       "-stroke '{colors[5]}' -fill '{colors[8]}' ",
       
       "-pointsize 250 -kerning 25 -strokewidth 2  ",
       "-annotate +1900+1300 'Population Density' ", 
       "images/iowa/titled_ia_pop.png +swap -gravity north ",
       "-composite images/iowa/titled_ia_pop_done.png")
)

image_read("images/iowa/titled_ia_pop_done.png") |> 
  image_scale(geometry = "46%x") |> 
  image_write("tracked_graphics/titled_ia_pop_small.png")

