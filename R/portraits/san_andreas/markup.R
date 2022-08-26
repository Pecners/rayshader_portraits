# Load packages and `add_main_annotations` function
for (f in list.files("R/utils")) {
  source(paste0("R/utils/", f, collapse = ""))
}

# Load `header` list with needed data
header <- readRDS("R/portraits/san_andreas/header.rds")

# Take original graphic from `render_highquality` and
# add annotations.

# Burning graphic
add_main_annotations(map = header$map, pal = header$pal, 
                     text_color = colorspace::darken(header$colors[5], .5), 
                     align = "right",
                     base_coords = c(.9, .1),
                     offset = 500,
                     main_text = "San Andreas Fault",
                     main_size = 300,
                     main_font = "Frijole",
                     secondary_text = "at Temblor Range",
                     secondary_size = 200,
                     secondary_font = "Rock Salt",
                     tertiary_text = glue("35° 16' 28.9236\" N\n",
                                          "119° 49' 35.9004\" W"),
                     tertiary_size = 125,
                     tertiary_font = "Denk One",
                     tertiary_offset = 500,
                     caption_size = 40,
                     caption_font = "Rock Salt",
                     twitter_icon_coords = c(-215, 60),
                     twitter_icon_size = 55,
                     data_source = "AWS Terrain Tiles",
                     original = header$outfile,
                     crop = c(5000, 5300),
                     crop_gravity = "northeast",
                     svg_file = NULL,
                     svg_coords = NULL,
                     svg_size = NULL,
                     inset = NULL,
                     inset_coords = NULL,
                     inset_size = NULL)

