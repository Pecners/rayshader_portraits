library(magick)
library(glue)

# load helpers
for (f in list.files("R/utils")) {
  source(paste0("R/utils/", f, collapse = ""))
}

# dimensions for original image

orig <- image_read("assets/pillars_of_creation.png")

w_ratio <- image_info(orig)$width / image_info(orig)$height

w <- round(6000 * w_ratio)

# Create a strip 1000 px high to add padding
strip <- image_crop(b_img, geometry = "x1000")

# main graphic with original image overlay
main <- image_read("images/pillars_of_creation/pillars_of_creation_img_z5.png")

b_img <- image_crop(main, geometry = "6000x1000", gravity = "north")

b_img_v <- image_rotate(b_img, 90)

h_pad <- image_crop(b_img, geometry = "6000x1000")
bh_pad <- image_append(c(h_pad, h_pad)) |> 
  image_crop(geometry = "6700x500")

v_pad <- image_append(c(b_img_v, b_img_v), stack = TRUE) |> 
  image_crop(geometry = "518x4750")

# read in other graphics

files <- c(
  "images/death_pillars/death_pillars_gray_jolla_z5.png",
  "images/fifth_pillars/fifth_pillars_pink_greens_z5.png",
  "images/fourth_pillars/fourth_pillars_glacier_arches2_z5.png",
  "images/third_pillars/third_pillars_pink_green_z5.png"
)

imgs <- image_read(files)

# Crop to remove blank space but without cutting shadows
imgs_cropped <- image_crop(imgs, geometry = "5000x4750+250+250", 
                           gravity = "southwest")

# combine other graphics for 2x2 sub-graphic
f_tiled1 <- image_crop(imgs[1:2], geometry = "3500x6000+750+300", gravity = "southwest") |> 
  image_append()
f_tiled2 <- image_crop(imgs[3:4], geometry = "3500x4750+750+0", gravity = "southwest") |> 
  image_append()
f_tiled2
f_tiled <- image_append(c(f_tiled1, f_tiled2), stack = TRUE) |> 
  image_scale(geometry = "x4750")
f_tiled

# add 2x2 to main graphic
f_main <- image_crop(main, geometry = "3000x4750-250+0", gravity = "center")
f_appended <- image_append(c(f_main, f_tiled))
fv_appended <- image_append(c(f_appended, v_pad))
fh_appended <- image_append(c(bh_pad, fv_appended), stack = TRUE)


# add title and caption
add_main_annotations(map = "pillars_together", pal = "none", 
                     text_color = "#0E0E0E", 
                     align = "center",
                     base_coords = c(.5, .04),
                     offset = 0,
                     main_text = "Pillars of Creation",
                     main_size = 400,
                     main_font = "Cormorant SC",
                     secondary_text = "",
                     secondary_size = 600,
                     secondary_font = "Cinzel",
                     tertiary_text = "",
                     tertiary_size = 750,
                     tertiary_offset = 1250,
                     tertiary_font = "Cinzel Decorative",
                     tertiary_weight = 700,
                     caption_size = 75,
                     caption_font = "Cormorant SC",
                     caption_coords = c(.5, .96),
                     caption_align = "center",
                     twitter_icon_coords = c(-70, 140),
                     twitter_icon_size = 50,
                     data_source = "NASA",
                     original = fh_appended,
                     crop = NULL,
                     #crop_gravity = "north",
                     crop_start = NULL,
                     svg_file = NULL,
                     svg_coords = NULL,
                     svg_size = NULL,
                     inset = NULL,
                     inset_coords = c(.27, .225),
                     inset_size = 3500,
                     small_size = 1900)
