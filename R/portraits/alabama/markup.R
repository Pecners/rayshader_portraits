library(tidyverse)
library(magick)
library(glue)
library(colorspace)

# Load `header` list with needed data
header <- readRDS("R/portraits/alabama/header.rds")
colors <- header$colors
swatchplot(colors)

text_color <- colors[1]

img <- image_read(header$outfile)


annot <- glue("This map shows population density of ",
              "{str_to_title('alabama')}. ",
              "Population estimates are bucketed ",
              "into 400 meter (about 1/4 mile) hexagons.") |> 
  str_wrap(45)
cat(annot)


cap <- glue("Graphic by Spencer Schien (@MrPecners) | ",
            "Kontur Population Data (Released June 30, 2022)")

img |> 
  image_crop(geometry = "8000x8000+0-100", gravity = "center") |> 
  image_write("images/alabama/titled_al_pop.png")

system(
  glue("convert -size 8000x8000 xc:none ",
       # Shadows
       "-gravity north -font Marhey-Bold ",
       "-pointsize 300 -kerning 175 -stroke '{colors[4]}' -fill '{colors[4]}' ",
       "-annotate -6x10-1025+400 'ALABAMA' ",
       "-background none -blur 500x100 ",
       "-pointsize 125 -kerning 100 ",
       "-annotate -7x10-1025+900 'Population Density' ",
       "-background none -blur 250x50 +repage ",
       
       "-stroke '{colors[1]}' -fill '{colors[1]}' ",
       "-pointsize 300 -kerning 175 -annotate -6x10-1025+400 'ALABAMA' ", 
       "-pointsize 125 -kerning 100 ",
       "-annotate -7x10-1025+900 'Population Density' ",
       "-font Marhey -pointsize 55 -kerning 15 ",
       "-annotate -7x10+1150+6370 '{cap}' ",
       # "-gravity north -annotate +0+1000 'Population' ", 
       # "-gravity northeast -kerning 200 -annotate +500+200 'Density' ",
       "images/alabama/titled_al_pop.png +swap ",
       "-composite images/alabama/titled_al_pop_done.png")
)

 image_read("images/alabama/titled_al_pop_done.png") |> 
  image_scale(geometry = "44%x") |> 
  image_write("tracked_graphics/titled_al_pop_small.png")

