library(tidyverse)
library(magick)
library(glue)
library(colorspace)

# Load `header` list with needed data
header <- readRDS("R/portraits/young_stellar_object/header.rds")
colors <- header$colors
swatchplot(colors)

text_color <- colors[7]

img <- image_read(header$outfile)

img |> 
  image_annotate(text = glue("Graphic: Spencer Schien (@MrPecners) | ",
                             "Data: NASA"),
                 gravity = "southeast",
                 location = "+200+100", font = "Cinzel Decorative",
                 color = alpha(colors[8], .75),
                 kerning = 20,
                 size = 50, weight = 700) |> 
  image_write("images/young_stellar_object/titled_yso.png")

system(
  glue("convert -size 8000x8000 xc:none ",
       # Shadows
       "-gravity west -font Cinzel-Decorative-Black ",
       "-pointsize 200 -kerning 100 -stroke '{colors[4]}' -fill '{colors[4]}' ",
       "-annotate +460-120 'A Star' ",
       "-background none ",
       "-kerning 100 -annotate +1260+480 'is Born' ",
       "-background none -blur 50x30 +repage ",
       
       # Foreground font
       "-font Cinzel-Decorative-Black -stroke '{colors[9]}' -fill '{colors[7]}' ",
       "-pointsize 200 -kerning 100 -annotate +500-100 'A Star' ", 
       "-kerning 100 -annotate +1300+500 'Is Born' ", 
       
       "images/young_stellar_object/titled_yso.png +swap ",
       "-composite images/young_stellar_object/titled_yso_done.png")
)


image_read("images/young_stellar_object/titled_yso_done.png") |> 
  image_scale(geometry = "47%x") |> 
  image_write("tracked_graphics/titled_yso_small.png")
