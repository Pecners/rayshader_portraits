# Load packages and `add_main_annotations` function
for (f in list.files("R/utils")) {
  source(paste0("R/utils/", f, collapse = ""))
}

# Load `header` list with needed data
header <- readRDS("R/portraits/glacier/header.rds")

# Take original graphic from `render_highquality` and
# add annotations.

# Burning graphic
add_main_annotations(map = header$map, pal = header$pal, 
                     text_color = colorspace::darken(header$colors[5], .5), 
                     align = "center",
                     base_coords = c(.78, .065),
                     offset = 550,
                     main_text = "Glacier",
                     main_size = 450,
                     main_font = "Rubik Distressed",
                     secondary_text = "National Park",
                     secondary_size = 125,
                     secondary_font = "Rock Salt",
                     caption_size = 40,
                     caption_font = "Rock Salt",
                     twitter_icon_coords = c(-350, 60),
                     twitter_icon_size = 55,
                     data_source = "USGS and AWS Terrain Tiles",
                     original = header$outfile,
                     crop = c(5000, 5000),
                     crop_gravity = "east",
                     caption_coords = NULL,
                     svg_file = NULL,
                     svg_coords = NULL,
                     svg_size = NULL,
                     inset = NULL,
                     inset_coords = NULL,
                     inset_size = NULL)


# Cleaner graphic
header$pal <- "glacier"
header$outfile <- "images/glacier/glacier_glacier_z12.png"
add_main_annotations(map = header$map, pal = header$pal, 
                     text_color = "white", 
                     align = "center",
                     base_coords = c(.78, .065),
                     offset = 550,
                     main_text = "Glacier",
                     main_size = 350,
                     main_font = "Spectral SC",
                     secondary_text = "National Park",
                     secondary_size = 140,
                     secondary_font = "Spectral SC",
                     caption_size = 40,
                     caption_font = "Spectral SC",
                     twitter_icon_coords = c(-275, 60),
                     twitter_icon_size = 37,
                     data_source = "USGS and AWS Terrain Tiles",
                     original = header$outfile,
                     crop = c(5000, 5000),
                     crop_gravity = "east",
                     caption_coords = NULL,
                     svg_file = NULL,
                     svg_coords = NULL,
                     svg_size = NULL,
                     inset = NULL,
                     inset_coords = NULL,
                     inset_size = NULL)
