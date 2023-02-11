library(tidyverse)
library(magick)
library(glue)

# Load `header` list with needed data
header <- readRDS("R/portraits/gc_oval/header.rds")
colors <- header$colors
swatchplot(colors)

text_color <- colors[5]

img <- image_read(header$outfile)

# Load blank plot to use as tile
blank <- "images/blank/forest_1.5_-20.png"
b_img <- image_read(blank)

# Create a strip 1000 px high to add padding
strip <- image_crop(b_img, geometry = "4000x4000")
pad <- image_append(rep(strip, 2), stack = TRUE)
wider <- image_append(c(pad, img))
#wider

inset <- image_read("images/gc_oval/glacier_arches2_inset.png")

wider |> 
  image_crop(geometry = "11000x8000+0+0", gravity = "west") |> 
  # image_annotate(text = "Grand Canyon",
  #                gravity = "north",
  #                location = "+200+200",
  #                font = "Cinzel Decorative",
  #                color = text_color,
  #                size = 350) |>
  image_annotate(text = glue("Graphic by Spencer Schien (@MrPecners) | ",
                             "Kontur Population Data (Released June 30, 2022)"),
                 gravity = "south",
                 location = "-2500+200", 
                 font = "Cinzel Decorative",
                 color = alpha(colors[5], .5),
                 size = 70, weight = 700,
                 kerning = 20) |> 
  image_composite(image_scale(inset, geometry = "80%x"),
                  gravity = "south",
                  offset = "-2800+800") |> 
  image_write("images/gc_oval/titled_gc_oval.png")

# Add title

system(
  glue("convert -size 11000x8000 xc:none ",
       # Shadows
       "-gravity northwest -font Cinzel-Decorative-Black ",
       "-pointsize 700 -kerning 100 -stroke '{colors[4]}' -fill '{colors[4]}' ",
       "-annotate +290+130 'The' ",
       "-background none ",
       "-annotate +790+1130 'Grand' ",
       "-background none ",
       "-annotate +1390+2130 'Canyon' ",
       "-background none -blur 50x50 +repage ",

       # Foreground font
       "-font Cinzel-Decorative-Black -stroke '{colors[4]}' -fill '{colors[6]}' ",
       "-pointsize 700 -kerning 100 -annotate +300+100 'The' ", 
       "-annotate +800+1100 'Grand' ", 
       "-annotate +1400+2100 'Canyon' ", 
       "-stroke '{alpha(colors[4], .25)}' -fill '{alpha(colors[4], .25)}' ",
       "-gravity south -pointsize 175 -kerning 100 -strokewidth 2  ",
       "-annotate -2800+1750 'ARIZONA' ",
       "images/gc_oval/titled_gc_oval.png +swap -gravity north ",
       "-composite images/gc_oval/titled_gc_oval_done.png")
)


image_read("images/gc_oval/titled_gc_oval_done.png") |> 
  image_scale(geometry = "37%x") |> 
  image_write("tracked_graphics/titled_gc_oval_small.png")

