library(tidyverse)
library(magick)
library(glue)
library(colorspace)

# Load `header` list with needed data
header <- readRDS("R/portraits/louisiana/header.rds")
colors <- header$colors
swatchplot(colors)

text_color <- colors[4]

img <- image_read(header$outfile)


annot <- glue("This map shows population density of ",
              "{str_to_title('louisiana')}. ",
              "Population estimates are bucketed ",
              "into 400 meter (about 1/4 mile) hexagons.") |> 
  str_wrap(45)
cat(annot)



img |> 
  image_crop(geometry = "x6000+0+150", gravity = "center") |>
  image_annotate(text = "Louisiana",
                 gravity = "north",
                 location = "+2300+400",
                 font = "Cinzel Decorative",
                 color = text_color,
                 size = 275, 
                 weight = 900,
                 kerning = 100) |>
  image_annotate(text = "Population Density",
                 gravity = "north",
                 location = "+2300+900",
                 font = "Cinzel Decorative",
                 color = text_color,
                 size = 150, 
                 weight = 700,
                 kerning = 50) |>
  # image_annotate(text = annot, gravity = "northeast",
  #                location = "+200+500", font = "El Messiri",
  #                color = alpha(text_color, .75),
  #                size = 115) |> 
  image_annotate(text = glue("Graphic by Spencer Schien (@MrPecners) | ",
                             "Kontur Population Data (Released June 30, 2022)"),
                 gravity = "south",
                 location = "+0+100", 
                 font = "Cinzel Decorative",
                 color = alpha(text_color, .75),
                 size = 60,
                 kerning = 20) |> 
  image_write("images/louisiana/titled_la_pop.png")


colorspace::contrast_ratio(rgb(137,	108,	100	, 0, maxColorValue = 255), colors[7])

# system(
#   glue(
#     "convert images/louisiana/titled_la_pop.png ",
#     "-gravity center -font Cinzel-Decorative-Black -pointsize 250 ", 
#     "-fill '{alpha(colors[4], .5)}' -stroke '{colors[4]}' -strokewidth 5 ",
#     "-draw 'roundrectangle 2750,2500 5250,3500 300,300' ",
#     "-stroke '{colors[4]}' -strokewidth 3 -fill '{colors[7]}' ",
#     "-kerning 100 -annotate +0-200 'Louisiana' ",
#     "-pointsize 150 -kerning 25 -strokewidth 2 ",
#     "-annotate -0+200 'Population Density' ",
#     "images/louisiana/titled_la_pop_done.png"
#   )
# )


image_read("images/louisiana/titled_la_pop.png") |> 
  image_scale(geometry = "49%x") |> 
  image_write("tracked_graphics/titled_la_pop_small.png")

