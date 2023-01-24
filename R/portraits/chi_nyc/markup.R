library(tidyverse)
library(magick)
library(glue)
library(colorspace)

# Load `header` list with needed data
header <- readRDS("R/portraits/chi_nyc/header.rds")
colors <- header$colors
swatchplot(colors)

text_color <- colors[5]

img <- image_read(header$outfile)


annot <- glue("This map shows population density of ",
              "{str_to_title('chi_nyc')}. ",
              "Population estimates are bucketed ",
              "into 400 meter (about 1/4 mile) hexagons.") |> 
  str_wrap(45)
cat(annot)



img |> 
  image_crop(geometry = "9500x7000+0+0", gravity = "center") |> 
  image_annotate(text = "COMPARATIVE", 
                 gravity = "north",
                 location = "+0+500", font = "El Messiri",
                 color = text_color,
                 size = 350, weight = 700) |> 
  image_annotate(text = "POPULATION", 
                 gravity = "north",
                 kerning = 25,
                 location = "+0+1100", font = "El Messiri",
                 color = text_color,
                 size = 350, weight = 700) |> 
  image_annotate(text = "DENSITY", 
                 gravity = "north",
                 kerning = 150,
                 location = "+0+1700", font = "El Messiri",
                 color = text_color,
                 size = 350, weight = 700) |> 
  # image_annotate(text = annot, gravity = "northeast",
  #                location = "+200+500", font = "El Messiri",
  #                color = alpha(text_color, .75),
  #                size = 115) |> 
  image_annotate(text = glue("Graphic: Spencer Schien (@MrPecners) | ",
                             "Kontur Population Data (Released June 30, 2022)"),
                 gravity = "south",
                 location = "+0+100", font = "El Messiri",
                 color = alpha(text_color, .5),
                 size = 80, weight = 700) |> 
  # image_annotate(text = "Graphic: Spencer Schien (@MrPecners)", gravity = "southwest",
  #                location = "+200+225", font = "El Messiri",
  #                color = alpha(text_color, .5),
  #                size = 80, weight = 700) |>
  image_write("images/chi_nyc/titled_chi_nyc_pop.png")

# I'm using system() because I don't think {magick} has the functionality
# to specify stroke and weight of the annotation, so I'm using IM cli code.

# Add Chicago lab

system(
  glue("convert images/chi_nyc/titled_chi_nyc_pop.png ",
       "-gravity southwest -font El-Messiri-Bold -pointsize 500 ", 
       "-stroke '{colors[5]}' -strokewidth 10 -fill '{colors[9]}' ",
       "-annotate +500+500 'Chicago' ",
       "images/chi_nyc/titled_chi_nyc_pop_.png")
)

# Add NYC lab

system(
  glue("convert images/chi_nyc/titled_chi_nyc_pop_.png ",
       "-gravity southeast -font El-Messiri-Bold -pointsize 500 ", 
       "-stroke '{colors[5]}' -strokewidth 10 -fill '{colors[14]}' ",
       "-annotate +500+500 'New York City' ",
       "images/chi_nyc/titled_chi_nyc_pop_done.png")
)

image_read("images/chi_nyc/titled_chi_nyc_pop_done.png") |> 
  image_scale(geometry = "43%x") |> 
  image_write("tracked_graphics/titled_chi_nyc_pop_small.png")

