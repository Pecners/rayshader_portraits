library(magick)
library(glue)

header <- readRDS("R/portraits/joshua_tree/header.rds")

colors <- header$colors

soften_edges <- function(f) {
  system(glue("magick {f} -alpha set -virtual-pixel transparent", 
              "-channel A -blur 500x6000  -level 50%,100% +channel",  
              ""))
  
  new <- image_read("soft_edge.png")
  return(image_composite(b_img, new))
}

# blank image
blank <- "images/blank/forest_1.5_-20.png"
b_img <- image_read(blank)

# half blank image for top
bb_img <- b_img |> 
  image_flip()
b_half <- bb_img |> 
  image_crop(geometry = "6000x4000", gravity = "south")

# blank image for bottom

bot_img <- bb_img |> 
  image_crop(geometry = "6000x2000")
  

# data |> 
#   filter(STATE == "CA" & UNIT_TYPE == "National Park") |> 
#   select(UNIT_NAME, Shape_Area) |> 
#   arrange(Shape_Area)

parks <- c(
  "Pinnacles" = "images/pinnacles/pinnacles_golden_brown_z14.png",
  "Lassen_Volcanic" = "images/lassen_volcanic/lassen_volcanic_golden_brown_z14.png",
  "Redwood" = "images/redwood/redwood_golden_brown_z13.png",
  "Channel_Islands" = "images/channel_islands/channel_islands_golden_brown_z12.png",
  "Sequoia" = "images/sequoia_again/sequoia_again_golden_brown_z13.png",
  "Kings_Canyon" = "images/kings_again/kings_again_golden_brown_z13.png",
  "Joshua_Tree" = "images/joshua_tree/joshua_tree_golden_brown_z12.png",
  "Yosemite" = "images/yosemite_again/yosemite_again_golden_brown_z12.png",
  "Death_Valley" = "images/death_again/death_again_golden_brown_z11.png"
)

walk2(parks, names(parks), function(m, o) {
  ind <- which(names(parks) == o)
  if (ind %in% c(4:6)) {
    this_b <- bb_img
  } else {
    this_b <- b_img
  }
  system(glue("magick {m} -alpha set -virtual-pixel transparent ", 
              "-channel A -blur 500x6000  -level 50%,100% +channel ",  
              "images/ca_nine/inds/{o}_soft.png"))
  
  new <- image_read(glue("images/ca_nine/inds/{o}_soft.png"))
  new_soft <- image_composite(this_b, new)
  image_write(new_soft, glue("images/ca_nine/inds/{o}_soft_done.png"))
})


soft_maps <- glue("images/ca_nine/inds/{names(parks)[order(names(parks))]}_soft_done.png")

imgs <- image_read(soft_maps)

# all_4x3 <- image_montage(c(rep(b_img, 2), imgs, b_img), geometry = "6000x6000", tile = "4x3")
# 
# image_write(all_4x3, "images/ca_nine/main_4x3.png", format = "png")

all_3x4 <- image_montage(imgs, geometry = "6000x6000", tile = "3x3")
top <- image_append(rep(b_half, 3), stack = FALSE)
bottom <- image_append(rep(bot_img, 3), stack = FALSE)

done <- image_append(c(top, all_3x4, bottom), stack = TRUE)

image_write(done, "images/ca_nine/main_3x4.png", format = "png")
# 
# img <- image_read("images/ca_nine/main_3x4.png")
# 
# img |> 
#   image_annotate(text = "CALIFORNIA",
#                  gravity = "north",
#                  location = "+0+1000",
#                  size = 600,
#                  kerning = 100,
#                  font = "Poller One",
#                  color = colors[8]) |> 
#   image_write("images/ca_nine/main_3x4_titled.png")
