# Load packages and `add_main_annotations` function
for (f in list.files("R/utils")) {
  source(paste0("R/utils/", f, collapse = ""))
}

# Load `header` list with needed data
header <- readRDS("R/portraits/great_basin/header.rds")

# Take original graphic from `render_highquality` and
# add annotations.

# Burning graphic
add_main_annotations(map = header$map, pal = header$pal, 
                     text_color = colorspace::darken(header$colors[2], .4), 
                     align = "right",
                     base_coords = c(.975, .065),
                     offset = 400,
                     main_text = "Great Basin",
                     main_size = 300,
                     main_font = "Cinzel Decorative",
                     secondary_text = "National Park",
                     secondary_size = 225,
                     secondary_font = "Cinzel",
                     caption_size = 65,
                     caption_font = "Cinzel",
                     twitter_icon_coords = c(-450, 60),
                     twitter_icon_size = 60,
                     data_source = "USGS and AWS Terrain Tiles",
                     original = header$outfile,
                     crop = c(4500, 5000),
                     crop_gravity = "east",
                     svg_file = NULL,
                     svg_coords = NULL,
                     svg_size = NULL,
                     inset = NULL,
                     inset_coords = NULL,
                     inset_size = NULL)
