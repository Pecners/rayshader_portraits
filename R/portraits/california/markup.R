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
  image_crop(geometry = "7750x7750+0+0", gravity = "southeast") |> 
  image_annotate(text = glue("Graphic: Spencer Schien (@MrPecners) | ",
                             "Kontur Population Data (Released June 30, 2022)"),
                 gravity = "southeast",
                 location = "+400+400", font = "El Messiri",
                 color = alpha(colors[8], .75),
                 kerning = 20,
                 size = 65, weight = 700) |> 
  image_write("images/california/titled_ca_pop.png")

system(
  glue("convert -size 7750x7750 xc:none ",
       "-gravity northwest -font Cinzel-Decorative-Black ",
       "-pointsize 300 -kerning 100 -stroke '{colors[7]}' -fill '{colors[7]}' ",
       "-annotate +0+0 'California' ",
       "-distort arc 55 -background none +repage ",
       
       # "-font Cinzel-Decorative-Black -stroke '{colors[9]}' -fill '{colors[7]}' ",
       # "-annotate +10+10 'California' ",
       # "-distort arc 55 -background none ",
       "-rotate -17 images/california/titled_ca_pop.png +swap ",
       "-gravity south -geometry +3000-1700 ",
       "-composite images/california/titled_ca_pop_one.png"
  )
)


system(
  glue("convert -size 7500x7000 xc:none ",
       # Shadows
       "-gravity northwest -font Cinzel-Decorative-Black ",
       "-pointsize 200 -kerning 100 -stroke '{colors[8]}' -fill '{colors[8]}' ",
       # "-annotate +{4590+250}+2980 'California' ",
       # "-distort arc 45 -background none ",
       # 
       # "-kerning 100 -annotate +{4190+250}+3980 'Population' ",
       # "-background none ",
       # "-kerning 200 -annotate +{3790+250}+4980 'Density' ",
       # "-background none -blur 50x30 +repage ",
       # # "-gravity north -pointsize 60 -kerning 50 ",
       # # "-stroke '{colors[9]}' -fill '{colors[9]}' -font Cinzel-Decorative-Black ",
       # # "-annotate -30x0-{600-250}+895 'San Francisco' -background none ",
       # # "-annotate -40x0-{2090-250}+3535 'Los Angeles' ",
       # # "-background none -blur 30x15 +repage ",
       # 
       # # Foreground font
       # "-gravity northwest ",
       # "-font Cinzel-Decorative-Black -stroke '{colors[9]}' -fill '{colors[7]}' ",
       # "-pointsize 200 -kerning 100 -annotate +{4600+250}+3000 'California' ", 
       # "-distort arc 45 -background none ",
       "-kerning 100 -annotate +{4200+350}+4000 'Population' ", 
       
       # city annotations
       "-kerning 200 -annotate +{3800+350}+5000 'Density' ",
       "-gravity north -pointsize 60 -kerning 50 ",
       "-annotate -30x0-{600-150}+{900+750} 'San Francisco' ",
       "-annotate -40x0-{2090-150}+{3540+750} 'Los Angeles' ",
       "images/california/titled_ca_pop_one.png +swap ",
       "-composite images/california/titled_ca_pop_done.png")
)

image_read("images/california/titled_ca_pop_done.png") |> 
  image_scale(geometry = "51%x") |> 
  image_write("tracked_graphics/titled_ca_pop_small.png")

