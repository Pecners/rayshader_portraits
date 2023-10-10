library(tidyverse)
library(magick)
library(glue)
library(colorspace)

# Load `header` list with needed data
header <- readRDS("R/portraits/inland_empire/header.rds")
colors <- header$colors
swatchplot(colors)

text_color <- colors[1] |> 
  darken(.35)

img <- image_read(header$outfile)
image_info(img)

cap <- glue("Graphic: Spencer Schien (@MrPecners) | ",
            "Kontur Population Data (Released June 30, 2022)")

img |> 
  image_crop(geometry = "8000x6000-312+0", gravity = "center") |> 
  # image_annotate(text = "Inland Empire", 
  #                gravity = "northwest",
  #                location = "+500+500", font = "Cinzel Decorative",
  #                color = lighten(colors[9], .5),
  #                size = 450, kerning = 100, weight = 900) |> 
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
image_write("images/inland_empire/titled_ie_pop.png")

# Population Density
system(
  glue("convert -size 7000x6200 xc:none -gravity northwest ",
       "-stroke black -fill black ",
       "-pointsize 175 -font Rock-Salt-Regular -kerning 50 ",
       "-annotate -2x0+800+700 'Population Density' ",
       "-background none -blur 250x50 +repage ",
       
       "-stroke '{colors[8]}' -fill white -strokewidth 10 ",
       "-annotate -2x0+800+700 'Population Density' ",
       "-distort arc 45 ",
       # "-gravity north -annotate +0+1000 'Population' ", 
       # "-gravity northeast -kerning 200 -annotate +500+200 'Density' ",
       "images/inland_empire/titled_ie_pop.png +swap ",
       "-composite images/inland_empire/titled_ie_pop_done.png")
)

# FINISHED THIS ONE IN ADOBE ILLUSTRATOR

# # WPB
# system(
#   glue("convert -size 7000x6200 xc:none -gravity east ",
#        "-stroke black -fill black ",
#        "-pointsize 80 -font Rock-Salt-Regular -kerning 20 ",
#        # "-pointsize 50 -font Rock-Salt-Regular -kerning 10 ",
#        "-annotate +1550-1400 'West Palm Beach' ",
#        # "-annotate +200-700 'West Palm Beach' ",
#        "-background none -blur 50x50 +repage ",
#        "-stroke '{colors[8]}' -fill white -strokewidth 2 ",
#        "-annotate +1550-1400 'West Palm Beach' ",
#        "images/inland_empire/titled_ie_pop_done.png +swap ",
#        "-composite images/inland_empire/titled_ie_pop_done_wpb.png")
# )
# 
# # Boca Raton
# system(
#   glue("convert -size 7000x6200 xc:none -gravity east ",
#        "-stroke black -fill black ",
#        "-pointsize 80 -font Rock-Salt-Regular -kerning 10 ",
#        "-annotate +2600-440 'Boca Raton' ",
#        "-background none -blur 50x50 +repage ",
#        
#        "-stroke '{colors[8]}' -fill white -strokewidth 2 ",
#        "-annotate +2600-440 'Boca Raton' ",
#        "images/inland_empire/titled_ie_pop_done_wpb.png +swap ",
#        "-composite images/inland_empire/titled_ie_pop_done_br.png")
# )
# 
# # Coral Springs
# system(
#   glue("convert -size 7000x6200 xc:none -gravity east ",
#        "-stroke black -fill black ",
#        "-pointsize 80 -font Rock-Salt-Regular -kerning 10 ",
#        "-annotate +3550-300 'Coral Springs' ",
#        "-background none -blur 50x50 +repage ",
#        
#        "-stroke '{colors[8]}' -fill white -strokewidth 2 ",
#        "-annotate +3550-300 'Coral Springs' ",
#        "images/inland_empire/titled_ie_pop_done_br.png +swap ",
#        "-composite images/inland_empire/titled_ie_pop_done_cs.png")
# )
# 
# # Fort Lauderdale
# system(
#   glue("convert -size 7000x6200 xc:none -gravity east ",
#        "-stroke black -fill black ",
#        "-pointsize 80 -font Rock-Salt-Regular -kerning 10 ",
#        "-annotate +3200+100 'Fort Lauderdale' ",
#        "-background none -blur 50x50 +repage ",
#        
#        "-stroke '{colors[8]}' -fill white -strokewidth 2 ",
#        "-annotate +3200+100 'Fort Lauderdale' ",
#        "images/inland_empire/titled_ie_pop_done_cs.png +swap ",
#        "-composite images/inland_empire/titled_ie_pop_done_fl.png")
# )
# 
# image_read("images/inland_empire/titled_ie_pop_done_fl.png") |> 
#   image_info()
# # Lines
# 
# system(
#   glue("convert images/inland_empire/titled_ie_pop_done_fl.png ",
#        "-stroke white -strokewidth 5 ",
#        "-draw 'line  6500,1850 6850,2050' ",
#        "images/inland_empire/titled_ie_pop_done_lines.png")
# )
# 
# image_read("images/inland_empire/titled_ie_pop_done_cap.png") |> 
#   image_scale(geometry = "50%x") |> 
#   image_write("tracked_graphics/titled_ie_pop_small.png")
