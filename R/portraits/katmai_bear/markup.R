# Load packages and `add_main_annotations` function
for (f in list.files("R/utils")) {
  source(paste0("R/utils/", f, collapse = ""))
}

# Load `header` list with needed data
header <- readRDS("R/portraits/katmai_bear/header.rds")

# Take original graphic from `render_highquality` and
# add annotations.

add_main_annotations(map = header$map, pal = header$pal, 
                     text_color = header$colors[1], 
                     align = "center",
                     base_coords = c(.25, .025),
                     offset = 300,
                     main_text = "Katmai",
                     main_size = 200,
                     main_font = "Frijole",
                     secondary_text = "National Park",
                     secondary_size = 75,
                     secondary_font = "Rock Salt",
                     caption_size = 20,
                     caption_font = "Rock Salt",
                     caption_coords = c(.8, .96),
                     caption_align = "center",
                     twitter_icon_coords = c(730, 65),
                     twitter_icon_size = 25,
                     data_source = "USGS and AWS Terrain Tiles",
                     original = header$outfile,
                     crop = c(3000, 2500),
                     crop_gravity = "north",
                     crop_start = c(0, 100),
                     svg_file = NULL,
                     svg_coords = NULL,
                     svg_size = NULL,
                     inset = NULL,
                     inset_coords = c(.725, .3),
                     inset_size = 1000)
