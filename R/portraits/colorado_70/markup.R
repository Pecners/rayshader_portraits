# Load packages and `add_main_annotations` function
source("R/utils/add_main_annotations.R")

# Load `header` list with needed data
header <- readRDS("R/portraits/bryce_canyon/header.rds")

# Take original graphic from `render_highquality` and
# add annotations.

add_main_annotations(map = header$map, pal = header$pal, 
                     text_color = header$colors[1], 
                     align = "center",
                     base_coords = c(.37, .1),
                     offset = 0,
                     main_text = "",
                     main_size = 400,
                     main_font = "Denk One",
                     secondary_text = "Over the Rockies",
                     secondary_size = 200,
                     secondary_font = "Denk One",
                     caption_size = 52,
                     caption_font = "Denk One",
                     twitter_icon_coords = c(-410, 60),
                     twitter_icon_size = 50,
                     data_source = "OpenStreetMap and AWS Terrain Tiles",
                     original = header$outfile,
                     # below crop width to 4750, leave height alone
                     crop = c("4500", ""),
                     svg_file = "R/portraits/colorado_70/I70.svg",
                     svg_coords = c(.15, .09),
                     svg_size = 300,
                     inset = "images/colorado_70/inset.png",
                     inset_coords = c(.77, .47),
                     inset_size = 750)


