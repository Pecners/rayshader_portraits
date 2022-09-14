# Load packages and `add_main_annotations` function
for (f in list.files("R/utils")) {
  source(paste0("R/utils/", f, collapse = ""))
}

# Load `header` list with needed data
header <- readRDS("R/portraits/olympic/header.rds")

# Take original graphic from `render_highquality` and
# add annotations.

add_main_annotations(map = header$map, pal = header$pal, 
                     text_color = colorspace::darken(header$colors[5], .25), 
                     align = "center",
                     base_coords = c(.25, .03),
                     offset = 750,
                     main_text = "Olympic",
                     main_size = 500,
                     main_font = "Cinzel Decorative",
                     secondary_text = "National Park",
                     secondary_size = 200,
                     secondary_font = "Cinzel",
                     caption_size = 80,
                     caption_font = "Cinzel",
                     caption_coords = c(.5, .97),
                     caption_align = "center",
                     twitter_icon_coords = c(-550, 100),
                     twitter_icon_size = 60,
                     data_source = "USGS and AWS Terrain Tiles",
                     original = header$outfile,
                     crop = NULL,
                     #crop_gravity = "north",
                     crop_start = NULL,
                     svg_file = NULL,
                     svg_coords = NULL,
                     svg_size = NULL,
                     inset = glue("images/{header$map}/final_inset.png"),
                     inset_coords = c(.65, .075),
                     inset_size = 1650)

# without inset

add_main_annotations(map = header$map, pal = header$pal, 
                     text_color = colorspace::darken(header$colors[5], .25), 
                     align = "center",
                     base_coords = c(.5, .05),
                     offset = 750,
                     main_text = "Olympic",
                     main_size = 500,
                     main_font = "Cinzel Decorative",
                     secondary_text = "National Park",
                     secondary_size = 200,
                     secondary_font = "Cinzel",
                     caption_size = 80,
                     caption_font = "Cinzel",
                     caption_coords = c(.5, .97),
                     caption_align = "center",
                     twitter_icon_coords = c(-550, 80),
                     twitter_icon_size = 60,
                     data_source = "USGS and AWS Terrain Tiles",
                     original = header$outfile,
                     crop = c(6000,5500),
                     crop_gravity = "north",
                     crop_start = c(0,500),
                     svg_file = NULL,
                     svg_coords = NULL,
                     svg_size = NULL,
                     inset = NULL,
                     inset_coords = c(.65, .075),
                     inset_size = 1650)
