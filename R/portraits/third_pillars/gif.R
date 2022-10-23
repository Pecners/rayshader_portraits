library(magick)

imgs <- c("tracked_graphics/pillars_of_creation_titled_img_insta_small.png",
          "tracked_graphics/death_pillars_titled_gray_jolla_insta_small.png",
          "tracked_graphics/third_pillars_titled_pink_green_insta_small.png",
          "tracked_graphics/fourth_pillars_titled_glacier_arches2_insta_small.png",
          "tracked_graphics/fifth_pillars_titled_pink_greens_insta_small.png")

inds <- c(1, 1, 2, 2, 3, 3, 4, 4, 5, 5, 4, 4, 3, 3, 2, 2, 1, 1)
imgs <- imgs[inds]

img_list <- lapply(imgs, image_read)

## join the images together
img_joined <- image_join(img_list)

## animate at 2 frames per second
img_animated <- image_resize(img_joined, '700') %>%
  image_morph(frames = 5) %>%
  image_animate(fps = 10, optimize = TRUE)

## view animated image
img_animated

## save to disk
image_write(image = img_animated,
            path = "tracked_graphics/pillars.gif")
