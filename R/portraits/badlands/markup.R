# Load packages and `add_main_annotations` function
for (f in list.files("R/utils")) {
  source(paste0("R/utils/", f, collapse = ""))
}

# Load `header` list with needed data
header <- readRDS("R/portraits/badlands/header.rds")

# Take original graphic from `render_highquality` and
# add annotations.

add_main_annotations(map = header$map, pal = header$pal, 
                     text_color = header$colors[1], 
                     align = "left",
                     base_coords = c(.05, .1),
                     offset = 550,
                     main_text = "Badlands",
                     main_size = 500,
                     main_font = "IM FELL English SC",
                     secondary_text = "National Park",
                     secondary_size = 300,
                     secondary_font = "IM FELL English SC",
                     caption_size = 60,
                     caption_font = "IM FELL English SC",
                     caption_coords = c(.98, .97),
                     caption_align = "right",
                     twitter_icon_coords = c(1400, 90),
                     twitter_icon_size = 45,
                     data_source = "USGS and AWS Terrain Tiles",
                     original = header$outfile,
                     crop = NULL,
                     #crop_gravity = "north",
                     crop_start = NULL,
                     svg_file = NULL,
                     svg_coords = NULL,
                     svg_size = NULL,
                     inset = NULL,
                     inset_coords = NULL,
                     inset_size = NULL)
