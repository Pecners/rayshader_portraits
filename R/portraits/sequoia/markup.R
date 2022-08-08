# Load packages and `add_main_annotations` function
source("R/utils/add_main_annotations.R")

# Load `header` list with needed data
header <- readRDS("R/portraits/sequoia/header.rds")

# Take original graphic from `render_highquality` and
# add annotations.

add_main_annotations(map = header$map, pal = header$pal, 
                     text_color = header$colors[1], 
                     align = "center",
                     base_coords = c(0.5, .01),
                     offset = 600,
                     main_text = "Sequoia",
                     main_size = 400,
                     main_font = "Denk One",
                     secondary_text = "National Park",
                     secondary_size = 150,
                     secondary_font = "Denk ONe",
                     caption_size = 52,
                     caption_font = "Denk One",
                     twitter_icon_coords = c(-290, 60),
                     twitter_icon_size = 50,
                     data_source = "USGS and AWS Terrain Tiles",
                     original = header$outfile,
                     # below crop width to 4750, leave height alone
                     crop = c(4750, ""))
