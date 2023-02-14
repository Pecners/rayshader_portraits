library(tidyverse)
library(magick)
library(glue)
library(colorspace)

# Load `header` list with needed data
header <- readRDS("R/portraits/california/header.rds")
colors <- header$colors
swatchplot(colors)

text_color <- colors[7]

img <- image_read(header$outfile)

img |> 
  image_crop(geometry = "7500x7000+0+0", gravity = "southeast") |> 
  image_annotate(text = glue("Graphic: Spencer Schien (@MrPecners) | ",
                             "Kontur Population Data (Released June 30, 2022)"),
                 gravity = "south",
                 location = "+0+100", font = "El Messiri",
                 color = alpha(colors[8], .75),
                 kerning = 20,
                 size = 65, weight = 700) |> 
  image_write("images/california/titled_ca_pop.png")


system(
  glue("convert -size 7500x7000 xc:none ",
       # Shadows
       "-gravity northwest -font Cinzel-Decorative-Black ",
       "-pointsize 200 -kerning 100 -stroke '{colors[4]}' -fill '{colors[4]}' ",
       "-annotate +4590+2980 'California' ",
       "-background none ",
       "-kerning 100 -annotate +4190+3980 'Population' ",
       "-background none ",
       "-kerning 200 -annotate +3790+4980 'Density' ",
       "-background none -blur 50x30 +repage ",
       "-gravity north -pointsize 60 -kerning 50 ",
       "-stroke '{colors[9]}' -fill '{colors[9]}' -font Cinzel-Decorative-Black ",
       "-annotate -30x0-600+895 'San Francisco' -background none ",
       "-annotate -40x0-2090+3535 'Los Angeles' ",
       "-background none -blur 30x15 +repage ",
       
       # Foreground font
       "-gravity northwest ",
       "-font Cinzel-Decorative-Black -stroke '{colors[9]}' -fill '{colors[7]}' ",
       "-pointsize 200 -kerning 100 -annotate +4600+3000 'California' ", 
       "-kerning 100 -annotate +4200+4000 'Population' ", 
       
       # city annotations
       "-kerning 200 -annotate +3800+5000 'Density' ",
       "-gravity north -pointsize 60 -kerning 50 ",
       "-font Cinzel-Decorative-Bold -stroke '{colors[9]}' ",
       "-annotate -30x0-600+900 'San Francisco' ",
       "-annotate -40x0-2090+3540 'Los Angeles' ",
       "images/california/titled_ca_pop.png +swap ",
       "-composite images/california/titled_ca_pop_done.png")
)

image_read("images/california/titled_ca_pop_done.png") |> 
  image_scale(geometry = "51%x") |> 
  image_write("tracked_graphics/titled_ca_pop_small.png")

