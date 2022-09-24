library(magick)

imgs <- c("images/voyageurs/voyageurs_titled_blue_green_highres.png",
          "images/voyageurs/voyageurs_titled_gray_jolla_highres.png")

imgs <- rep(imgs[c(1, 1, 2, 2, 1)], 2)

img_list <- lapply(imgs, image_read)

## join the images together
img_joined <- image_join(img_list)

## animate at 2 frames per second
img_animated <- image_resize(img_joined, '700') %>%
  image_morph(frames = 20) %>%
  image_animate(fps = 25, optimize = TRUE)

## view animated image
img_animated

## save to disk
image_write(image = img_animated,
            path = "images/voyageurs/voyageurs.gif")

file.copy("images/voyageurs/voyageurs.gif",
          "tracked_graphics/voyageurs.gif")
