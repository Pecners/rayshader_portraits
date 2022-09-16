# Load packages and `add_main_annotations` function
for (f in list.files("R/utils")) {
  source(paste0("R/utils/", f, collapse = ""))
}

# Load `header` list with needed data
header <- readRDS("R/portraits/rainier/header.rds")

# Take original graphic from `render_highquality` and
# add annotations.

add_main_annotations(map = header$map, pal = header$pal, 
                     text_color = colorspace::darken(header$colors[5], .25), 
                     align = "center",
                     base_coords = c(.5, .03),
                     offset = 700,
                     main_text = "Mount Rainier",
                     main_size = 400,
                     main_font = "Cinzel Decorative",
                     secondary_text = "National Park",
                     secondary_size = 300,
                     secondary_font = "Cinzel",
                     caption_size = 80,
                     caption_font = "Cinzel",
                     caption_coords = c(.5, .97),
                     caption_align = "center",
                     twitter_icon_coords = c(-550, 90),
                     twitter_icon_size = 60,
                     data_source = "USGS and AWS Terrain Tiles",
                     original = header$outfile,
                     crop = c(5500,5750),
                     crop_gravity = "north",
                     crop_start = c(250,250),
                     svg_file = NULL,
                     svg_coords = NULL,
                     svg_size = NULL,
                     inset = NULL,
                     inset_coords = c(.65, .075),
                     inset_size = 1650)
