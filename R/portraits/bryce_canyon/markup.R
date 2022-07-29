# Load packages and `add_main_annotations` function
source("R/utils/add_main_annotations.R")

# Load `header` list with needed data
header <- readRDS("R/portraits/bryce_canyon/header.rds")

# Take original graphic from `render_highquality` and
# add annotations.

add_main_annotations(map = header$map, pal = header$pal, 
                     text_color = header$colors[5], 
                     align = "center",
                     base_coords = c(.35, .05),
                     offset = 400,
                     main_text = "Bryce Canyon",
                     main_size = 300,
                     main_font = "Frijole",
                     secondary_text = "National Park",
                     secondary_size = 150,
                     secondary_font = "Rock Salt",
                     caption_size = 52,
                     data_source = "USGS and AWS Terrain Tiles",
                     original = header$outfile)
