# Load packages and `add_main_annotations` function
for (f in list.files("R/utils")) {
  source(paste0("R/utils/", f, collapse = ""))
}

# Load `header` list with needed data
header <- readRDS("R/portraits/kobuk/header.rds")

# Take original graphic from `render_highquality` and
# add annotations.

add_main_annotations(map = header$map, pal = header$pal, 
                     text_color = header$colors[1], 
                     align = "center",
                     base_coords = c(.7, .06),
                     offset = 650,
                     main_text = "Kobuk Valley",
                     main_size = 350,
                     main_font = "Cinzel Decorative",
                     secondary_text = "National Park",
                     secondary_size = 250,
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
                     inset = NULL,
                     inset_coords = c(.725, .3),
                     inset_size = 1000)
