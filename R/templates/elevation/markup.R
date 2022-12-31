# Load packages and `add_main_annotations` function
for (f in list.files("R/utils")) {
  source(paste0("R/utils/", f, collapse = ""))
}

# Load `header` list with needed data
header <- readRDS("R/portraits/CONFIG_MAP/header.rds")

# Take original graphic from `render_highquality` and
# add annotations.

add_main_annotations(map = header$map, pal = header$pal, 
                     text_color = header$colors[1], 
                     align = "center",
                     base_coords = c(.725, .1),
                     offset = 650,
                     main_text = "Capitol Reef",
                     main_size = 400,
                     main_font = "Tapestry",
                     secondary_text = "National Park",
                     secondary_size = 200,
                     secondary_font = "Tapestry",
                     caption_size = 80,
                     caption_font = "Tapestry",
                     caption_coords = c(.5, .97),
                     caption_align = "center",
                     twitter_icon_coords = c(-500, 100),
                     twitter_icon_size = 60,
                     data_source = "USGS and AWS Terrain Tiles",
                     original = header$outfile,
                     crop = NULL,
                     #crop_gravity = "north",
                     crop_start = NULL,
                     svg_file = NULL,
                     svg_coords = NULL,
                     svg_size = NULL,
                     inset = glue("images/{header$map}/{header$pal}_inset.png"),
                     inset_coords = c(.725, .3),
                     inset_size = 1000)
