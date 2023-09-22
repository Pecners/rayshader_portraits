library(tidyverse)
library(magick)
library(glue)
library(colorspace)

# Load `header` list with needed data
header <- readRDS("R/portraits/georgia_country/header.rds")
colors <- header$colors
swatchplot(colors)

text_color <- colors[9]

img <- image_read(header$outfile)
image_info(img)

# s <- darken("#9a9397", .1)
# 
# shadow <- "#9a9397"
# inset <- image_read("images/georgia_country/tam_inset.png")


img |> 
  image_crop(geometry = "8000x6000+0+500", gravity = "center") |> 
  image_annotate(text = "GEORGIA", 
                 gravity = "northwest",
                 location = "+3100+600", font = "Poller One",
                 color = text_color, kerning = 100,
                 size = 400, weight = 700) |> 
  image_annotate(text = "POPULATION DENSITY",
                 gravity = "northwest",
                 location = "+3800+1200", font = "Amarante",
                 color = colors[8], kerning = 50,
                 weight = 700,
                 size = 300) |>
  image_annotate(text = glue("Graphic by Spencer Schien (@MrPecners) | ",
                             "Kontur Population Data (Released June 30, 2022)"),
                 gravity = "northwest",
                 location = "+3800+1575", font = "Amarante",
                 color = colors[8],
                 kerning = 14,
                 size = 60) |>
  # image_composite(image_scale(inset, geometry = "75%x"),
  #                 gravity = "southwest",
  #                 offset = "+500+750") |> 
  image_write("images/georgia_country/titled_geo_pop.png")

# Russia
system(
  glue("convert -size 4000x2000 xc:none -gravity Center ",
       
       
       "-stroke '{alpha(colors[10], .1)}' -fill '{alpha(colors[10], .1)}' ",
       "-pointsize 125 -kerning 300 -font Poller-One ",
       "-annotate +0+0 'RUSSIA' ",
       "-distort Arc 75 -background none +repage ",
       
       # "-fill '{colors[2]}' -stroke '{colors[2]}' -strokewidth 5 ",
       # "-annotate -3x0-1150+700 'Population Density' ",
       # "-gravity north -annotate +0+1000 'Population' ", 
       # "-gravity northeast -kerning 200 -annotate +500+200 'Density' ",
       "-rotate 25 images/georgia_country/titled_geo_pop.png +swap ",
       "-gravity center -geometry +2000+0 ",
       "-composite images/georgia_country/titled_geo_pop_done.png")
)

# black sea
system(
  glue("convert -size 4000x2000 xc:none -gravity Center ",
       
       
       "-stroke '{alpha(colors[10], .1)}' -fill '{alpha(colors[10], .1)}' ",
       "-pointsize 125 -kerning 75 -font Poller-One ",
       "-annotate +0+0 'BLACK SEA' ",
       "-distort Arc 300 -background none +repage ",
       
       # "-fill '{colors[2]}' -stroke '{colors[2]}' -strokewidth 5 ",
       # "-annotate -3x0-1150+700 'Population Density' ",
       # "-gravity north -annotate +0+1000 'Population' ", 
       # "-gravity northeast -kerning 200 -annotate +500+200 'Density' ",
       "-rotate 90 images/georgia_country/titled_geo_pop_done.png +swap ",
       "-gravity center -geometry -3000-500 ",
       "-composite images/georgia_country/titled_geo_pop_bs.png")
)

# turkey
system(
  glue("convert -size 4000x2000 xc:none -gravity Center ",
       
       
       "-stroke '{alpha(colors[10], .1)}' -fill '{alpha(colors[10], .1)}' ",
       "-pointsize 125 -kerning 75 -font Poller-One ",
       "-annotate +0+0 'TURKEY' ",
       "-distort Arc 75 -background none +repage ",
       
       # "-fill '{colors[2]}' -stroke '{colors[2]}' -strokewidth 5 ",
       # "-annotate -3x0-1150+700 'Population Density' ",
       # "-gravity north -annotate +0+1000 'Population' ", 
       # "-gravity northeast -kerning 200 -annotate +500+200 'Density' ",
       "-rotate 30 images/georgia_country/titled_geo_pop_bs.png +swap ",
       "-gravity center -geometry -1500+1100 ",
       "-composite images/georgia_country/titled_geo_pop_turkey.png")
)

# armenia
system(
  glue("convert -size 4000x2000 xc:none -gravity Center ",
       
       
       "-stroke '{alpha(colors[10], .1)}' -fill '{alpha(colors[10], .1)}' ",
       "-pointsize 125 -kerning 75 -font Poller-One ",
       "-annotate +0+0 'ARMENIA' ",
       "-distort Arc 75 -background none +repage ",
       
       # "-fill '{colors[2]}' -stroke '{colors[2]}' -strokewidth 5 ",
       # "-annotate -3x0-1150+700 'Population Density' ",
       # "-gravity north -annotate +0+1000 'Population' ", 
       # "-gravity northeast -kerning 200 -annotate +500+200 'Density' ",
       "-rotate 10 images/georgia_country/titled_geo_pop_turkey.png +swap ",
       "-gravity center -geometry +300+1800 ",
       "-composite images/georgia_country/titled_geo_pop_armenia.png")
)

# azerbaijan
system(
  glue("convert -size 4000x2000 xc:none -gravity Center ",
       
       
       "-stroke '{alpha(colors[10], .1)}' -fill '{alpha(colors[10], .1)}' ",
       "-pointsize 125 -kerning 75 -font Poller-One ",
       "-annotate +0+0 'AZERBAIJAN' ",
       "-rotate 180 -distort Arc '75 180' -background none +repage ",
       
       # "-fill '{colors[2]}' -stroke '{colors[2]}' -strokewidth 5 ",
       # "-annotate -3x0-1150+700 'Population Density' ",
       # "-gravity north -annotate +0+1000 'Population' ", 
       # "-gravity northeast -kerning 200 -annotate +500+200 'Density' ",
       "-rotate 10 images/georgia_country/titled_geo_pop_armenia.png +swap ",
       "-gravity center -geometry +2500+2000 ",
       "-composite images/georgia_country/titled_geo_pop_azer.png")
)

image_read("images/georgia_country/titled_geo_pop.png") |> 
  image_scale(geometry = "46%x") |> 
  image_write("tracked_graphics/titled_geo_pop_small.png")