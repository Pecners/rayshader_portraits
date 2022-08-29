# Load packages and `add_main_annotations` function
for (f in list.files("R/utils")) {
  source(paste0("R/utils/", f, collapse = ""))
}

# Load `header` list with needed data
header <- readRDS("R/portraits/eye_of_sahara/header.rds")

# Take original graphic from `render_highquality` and
# add annotations.

# Burning graphic
add_main_annotations(map = header$map, pal = header$pal, 
                     text_color = header$colors[1], 
                     align = "left",
                     base_coords = c(.025, .1),
                     offset = 250,
                     main_text = "Eye of the Sahara",
                     main_size = 200,
                     main_font = "Tapestry",
                     secondary_text = "",
                     secondary_size = 250,
                     secondary_font = "Tapestry",
                     caption_size = 40,
                     caption_font = "Tapestry",
                     caption_coords = c(.98, .95),
                     caption_align = "right",
                     twitter_icon_coords = c(1100, 85),
                     twitter_icon_size = 35,
                     data_source = "AWS Terrain Tiles",
                     original = header$outfile,
                     crop = c(4000, 5000),
                     #crop_gravity = "north",
                     crop_start = c(850,0),
                     svg_file = NULL,
                     svg_coords = NULL,
                     svg_size = NULL,
                     inset = NULL,
                     inset_coords = NULL,
                     inset_size = NULL)

