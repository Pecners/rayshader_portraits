# Load packages and `add_main_annotations` function
for (f in list.files("R/utils")) {
  source(paste0("R/utils/", f, collapse = ""))
}

# Load `header` list with needed data
header <- readRDS("R/portraits/canyonlands/header.rds")

# Take original graphic from `render_highquality` and
# add annotations.

# Burning graphic
add_main_annotations(map = header$map, pal = header$pal, 
                     text_color = header$colors[1], 
                     align = "center",
                     base_coords = c(.25, .25),
                     offset = 550,
                     main_text = "Canyonlands",
                     main_size = 350,
                     main_font = "Tapestry",
                     secondary_text = "National Park",
                     secondary_size = 200,
                     secondary_font = "Tapestry",
                     caption_size = 80,
                     caption_font = "Tapestry",
                     caption_coords = c(.5, .97),
                     caption_align = "center",
                     twitter_icon_coords = c(-500, 70),
                     twitter_icon_size = 65,
                     data_source = "USGS and AWS Terrain Tiles",
                     original = header$outfile,
                     crop = c(5000,5250),
                     crop_gravity = "southwest",
                     crop_start = NULL,
                     svg_file = NULL,
                     svg_coords = NULL,
                     svg_size = NULL,
                     inset = glue("images/{header$map}/{header$pal}_inset.png"),
                     inset_coords = c(.25, .45),
                     inset_size = 750)
