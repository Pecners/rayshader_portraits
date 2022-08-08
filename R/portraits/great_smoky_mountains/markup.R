# Load packages and `add_main_annotations` function
source("R/utils/add_main_annotations.R")

# Load `header` list with needed data
header <- readRDS("R/portraits/great_smoky_mountains/header.rds")

# Take original graphic from `render_highquality` and
# add annotations.

add_main_annotations(map = header$map, 
                     pal = header$pal, 
                     text_color = header$colors[3], 
                     align = "center",
                     base_coords = c(.35, .075),
                     offset = 400,
                     main_text = "Great Smoky Mountains",
                     main_size = 300,
                     main_font = "Old Dreams",
                     secondary_text = "National Park",
                     secondary_size = 150,
                     secondary_font = "Old Dreams",
                     caption_size = 52,
                     caption_font = "Rock Salt",
                     data_source = "USGS and AWS Terrain Tiles",
                     original = header$outfile,
                     crop = c(5000, 2435))

# write_lines(
#   glue("## [{header$map_lab}](R/portraits/{map})\n\n",
#        "![{header$map_lab}](tracked_graphics/smoky_titled_gray_jolla_insta_small.png)"),
#   glue("R/portraits/{map}/{map}.md")
# )


