library(tidyverse)
library(magick)
library(glue)

# Load `header` list with needed data
header <- readRDS("R/portraits/new_jersey/header.rds")
colors <- header$colors
swatchplot(colors)

text_color <- colors[4]

img <- image_read(header$outfile)


annot <- glue("This map shows population density of ",
              "{str_to_title('new_jersey')}. ",
              "Population estimates are bucketed ",
              "into 400 meter (about 1/4 mile) hexagons.") |> 
  str_wrap(45)
cat(annot)



img |> 
  # image_crop(geometry = "x4000+400+0", gravity = "center") |> 
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
                 location = "+0+200", 
                 font = "Cinzel Decorative",
                 color = alpha(text_color, .5),
                 size = 80, weight = 700,
                 kerning = 20) |> 
  image_write("images/new_jersey/titled_nj_pop.png")

system(
  glue("convert -size 10000x10000 xc:none ",
       # Shadows
       "-gravity north -font Cinzel-Decorative-Bold ",
       "-pointsize 500 -kerning 100 -stroke '{colors[4]}' -fill '{colors[4]}' ", 
       "-annotate +2420+685 'New Jersey' ",
       "-background none -blur 50x15 +repage ",
       "-pointsize 300 -kerning 25 -stroke '{colors[4]}' -fill '{colors[4]}' ", 
       "-annotate +2365+1490 'Population Density' ",
       "-background none -blur 30x10 +repage ",
       # Foreground font
       "-font Cinzel-Decorative-Bold ",
       "-stroke '{colors[4]}' -strokewidth 5 -fill '{colors[7]}' ",
       "-pointsize 500 -kerning 100 -annotate +2400+700 'New Jersey' ", 
       "-stroke '{colors[4]}' -fill '{colors[7]}' ",
       
       "-pointsize 300 -kerning 25 -strokewidth 2  ",
       "-annotate +2350+1500 'Population Density' ", 
       "images/new_jersey/titled_nj_pop.png +swap -gravity north ",
       "-composite images/new_jersey/titled_nj_pop_done.png")
)

image_read("images/new_jersey/titled_nj_pop_done.png") |> 
  image_scale(geometry = "36%x") |> 
  image_write("tracked_graphics/titled_nj_pop_small.png")

