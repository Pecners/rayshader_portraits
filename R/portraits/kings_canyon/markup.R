# Load packages and `add_main_annotations` function
for (f in list.files("R/utils")) {
  source(paste0("R/utils/", f, collapse = ""))
}

# Load `header` list with needed data
header <- readRDS("R/portraits/kings_canyon/header.rds")

# Take original graphic from `render_highquality` and
# add annotations.

add_main_annotations(map = header$map, pal = header$pal, 
                     text_color = colorspace::darken(header$colors[1], .1), 
                     align = "right",
                     base_coords = c(.95, .05),
                     offset = 200,
                     main_text = "Kings Canyon",
                     main_size = 200,
                     main_font = "Spectral SC",
                     secondary_text = "National Park",
                     secondary_size = 150,
                     secondary_font = "Spectral SC",
                     caption_size = 40,
                     caption_font = "Spectral SC",
                     twitter_icon_coords = c(-275, 60),
                     twitter_icon_size = 37,
                     data_source = "USGS and AWS Terrain Tiles",
                     original = header$outfile,
                     crop = c("3000", "3000"),
                     svg_file = NULL,
                     svg_coords = NULL,
                     svg_size = NULL,
                     inset = NULL,
                     inset_coords = NULL,
                     inset_size = NULL)


