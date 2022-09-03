# This file combines other portraits for the Mighty Five
# National Parks of Utah.

library(MetBrewer)
library(magick)
library(glue)
library(tidyverse)
library(colorspace)

# load helpers
for (f in list.files("R/utils")) {
  source(paste0("R/utils/", f, collapse = ""))
}

# Load blank plot to use as tile
blank <- "images/blank/forest_1.5_-20.png"
b_img <- image_read(blank)

# Create a strip 1000 px high to add padding
strip <- image_crop(b_img, geometry = "x1000")
pad <- image_append(c(strip, strip, strip))

# Read individual portriats
maps <- c("arches/arches_okeeffe_z14.png",
          "bryce/bryce_okeeffe_z14.png",
          "canyonlands/canyonlands_okeeffe_z13.png",
          "capitol_reef/capitol_reef_okeeffe_z13.png",
          "zion/zion_okeeffe_z13.png")

mighty_5 <- glue("images/{maps}")

imgs <- image_read(mighty_5)

# Set up rows of images, then append the rows

# row 1
row1 <- image_montage(c(b_img, imgs[1:2]), geometry = "6000X6000+0+0", tile = "3x1")

# row 2
row2 <- image_montage(imgs[3:5], geometry = "6000X6000+0+0", tile = "3x1")

canvas <- image_append(c(pad, row1, pad, row2, pad), stack = TRUE)

# Add individual portrait titles

xs <- rep(.33/2 + c(0:2) * .33, 2)
ys <- c(rep(.06, 3), # row 1 relative coords
        rep(.5, 3)) # row 2

nc <- map(1:6, function(i) normalize_coords(canvas, c(xs[i], ys[i]), align = "center"))

# These are the title annotations
titles <- c(
  "",
  "Arches",
  "Bryce Canyon",
  "Canyonlands",
  "Capitol Reef",
  "Zion"
)

# Use darker red for text color
colors <- met.brewer("OKeeffe1")
text_color <- darken(colors[1], .5)

# Add annotation to canvas one at a time
for (i in 1:6) {
  print(nc[[i]]$loc_coords)
  canvas <- image_annotate(canvas, text = titles[i], gravity = "north",
                 location = nc[[i]]$loc_coords, size = 300, font = "Cinzel",
                 color = text_color)
}

# image_write(canvas, "images/mighty_5/mighty_5.png", format = "png")

# Add main annotations with same function used for normal portraits

ff <- add_main_annotations(map = "mighty_5", pal = "okeeffe", 
                           text_color = text_color, 
                           align = "center",
                           base_coords = c(.195, .05),
                           offset = 1500,
                           main_text = "Mighty Five",
                           main_size = 800,
                           main_font = "Cinzel Decorative",
                           secondary_text = "National Parks of",
                           secondary_size = 550,
                           secondary_font = "Cinzel",
                           tertiary_text = "Utah",
                           tertiary_size = 1900,
                           tertiary_offset = 1250,
                           tertiary_font = "Cinzel Decorative",
                           tertiary_weight = 700,
                           caption_size = 200,
                           caption_font = "Cinzel",
                           caption_coords = c(.5, .97),
                           caption_align = "center",
                           twitter_icon_coords = c(-1375, 250),
                           twitter_icon_size = 150,
                           data_source = "USGS and AWS Terrain Tiles",
                           original = canvas,
                           crop = NULL,
                           #crop_gravity = "north",
                           crop_start = NULL,
                           svg_file = NULL,
                           svg_coords = NULL,
                           svg_size = NULL,
                           inset = NULL,
                           inset_coords = NULL,
                           inset_size = NULL)

