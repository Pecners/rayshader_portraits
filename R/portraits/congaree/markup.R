# Load packages and `add_main_annotations` function
for (f in list.files("R/utils")) {
  source(paste0("R/utils/", f, collapse = ""))
}

# Load `header` list with needed data
header <- readRDS("R/portraits/congaree/header.rds")

# Take original graphic from `render_highquality` and
# add annotations.

add_main_annotations(map = header$map, pal = header$pal, 
                     text_color = header$colors[1], 
                     align = "center",
                     base_coords = c(.25, .05),
                     offset = 700,
                     main_text = "Congaree",
                     main_size = 500,
                     main_font = "Herculanum",
                     secondary_text = "National Park",
                     secondary_size = 300,
                     secondary_font = "Herculanum",
                     caption_size = 80,
                     caption_font = "Skia",
                     caption_coords = c(.5, .97),
                     caption_align = "center",
                     twitter_icon_coords = c(-480, 80),
                     twitter_icon_size = 60,
                     data_source = "USGS and AWS Terrain Tiles",
                     original = header$outfile,
                     crop = c(6000,5000),
                     crop_gravity = "north",
                     crop_start = c(0, 0),
                     svg_file = NULL,
                     svg_coords = NULL,
                     svg_size = NULL,
                     inset = glue("images/{header$map}/final_inset.png"),
                     inset_coords = c(.7, .075),
                     inset_size = 2500)
