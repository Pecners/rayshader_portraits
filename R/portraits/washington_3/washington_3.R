# This file combines other portraits for the Mighty Five
# National Parks of Utah.

library(MetBrewer)
library(magick)
library(glue)
library(tidyverse)
library(colorspace)
library(NatParksPalettes)

# load helpers
for (f in list.files("R/utils")) {
  source(paste0("R/utils/", f, collapse = ""))
}

soften_edges <- function(f) {
  system(glue("magick {f} -alpha set -virtual-pixel transparent", 
              "-channel A -blur 500x6000  -level 50%,100% +channel",  
              ""))
  
  new <- image_read("soft_edge.png")
  return(image_composite(b_img, new))
}

# Load blank plot to use as tile
blank <- "images/blank/forest_1.5_-20.png"
b_img <- image_read(blank)

# Create a strip 1000 px high to add padding
strip <- image_crop(b_img, geometry = "x1000")
pad <- image_append(c(strip, strip)) 
v_pad <- image_append(c(pad, pad)) |> 
  image_rotate(90) |> 
  image_crop(geometry = "1000x15000") 

# Read individual portriats
maps <- c("olympic/olympic_glacier_arches2_z12.png",
          "rainier/rainier_glacier_arches2_z13.png",
          "north_cascade/north_cascade_glacier_arches2_z12.png")

walk2(maps, c("olympic", "rainier", "north_cascade"), function(m, o) {
  system(glue("magick images/{m} -alpha set -virtual-pixel transparent ", 
              "-channel A -blur 500x6000  -level 50%,100% +channel ",  
              "images/washington_3/{o}_soft.png"))
  
  new <- image_read(glue("images/washington_3/{o}_soft.png"))
  new_soft <- image_composite(b_img, new)
  image_write(new_soft, glue("images/washington_3/{o}_soft_done.png"))
})

soft_maps <- c(
  "images/washington_3/olympic_soft_done.png",
  "images/washington_3/rainier_soft_done.png",
  "images/washington_3/north_cascade_soft_done.png"
)

imgs <- image_read(soft_maps)

# Set up rows of images, then append the rows

# row 1
row1 <- image_montage(c(b_img, imgs[1]), geometry = "6000X6000+0+0", tile = "2x1")

# row 2
row2 <- image_montage(c(imgs[3:2]), geometry = "6000X6000+0+0", tile = "2x1")

canvas <- image_append(c(pad, row1, pad, row2, pad), stack = TRUE)
f_canvas <- image_append(c(v_pad, canvas, v_pad))

#image_write(f_canvas, "images/washington_3/inter.png")

# Add individual portrait titles

xs <- rep(c(.25, .75), 2)
ys <- c(rep(.1, 2), # row 1 relative coords
        rep(.525, 2)) # row 2

nc <- map(1:4, function(i) normalize_coords(f_canvas, c(xs[i], ys[i]), align = "center"))

# These are the title annotations
titles <- c(
  "",
  "Olympic",
  "North Cascades",
  "Mount Rainier"
)

# Use darker red for text color
pal <- "glacier_arches2"

c1 <- natparks.pals("Glacier")
c2 <- natparks.pals("Arches2")
colors <- c(rev(c1[2:5]), c2[2:5], "white")
text_color <- colorspace::darken(header$colors[5], .25)

# Add annotation to canvas one at a time
for (i in 1:4) {
  print(nc[[i]]$loc_coords)
  f_canvas <- image_annotate(f_canvas, text = titles[i], gravity = "north",
                           location = nc[[i]]$loc_coords, size = 300, font = "Cinzel",
                           color = text_color)
}

# image_write(canvas, "images/mighty_5/mighty_5.png", format = "png")

# Add main annotations with same function used for normal portraits

ff <- add_main_annotations(map = "washington_3", pal = pal, 
                           text_color = text_color, 
                           align = "center",
                           base_coords = c(.275, .05),
                           offset = 0,
                           main_text = "",
                           main_size = 800,
                           main_font = "Cinzel Decorative",
                           secondary_text = "National Parks of",
                           secondary_size = 600,
                           secondary_font = "Cinzel",
                           tertiary_text = "Washington",
                           tertiary_size = 750,
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
                           original = f_canvas,
                           crop = NULL,
                           #crop_gravity = "north",
                           crop_start = NULL,
                           svg_file = NULL,
                           svg_coords = NULL,
                           svg_size = NULL,
                           inset = "images/washington_3/final_inset.png",
                           inset_coords = c(.27, .225),
                           inset_size = 3500,
                           small_size = 2500)



