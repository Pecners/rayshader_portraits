# Load packages and `add_main_annotations` function
for (f in list.files("R/utils")) {
  source(paste0("R/utils/", f, collapse = ""))
}

# Load `header` list with needed data
header <- readRDS("R/portraits/fifth_pillars/header.rds")

# Take original graphic from `render_highquality` and
# add annotations.

add_main_annotations(map = header$map, pal = header$pal, 
                     text_color = header$colors[4], 
                     align = "center",
                     base_coords = c(.775, .325),
                     offset = 0,
                     main_text = "Pillars of Creation",
                     main_size = 125,
                     main_font = "Cinzel Decorative",
                     secondary_text = "",
                     secondary_size = 200,
                     secondary_font = "Tapestry",
                     tertiary_text = paste0("Graphic by Spencer Schien\n(    @MrPecners)\n",
                                            "Data from NASA"),
                     tertiary_size = 75,
                     tertiary_font = "Cinzel",
                     tertiary_offset = 300,
                     caption = FALSE,
                     twitter_icon_coords = c(980, 2390),
                     twitter_icon_size = 60,
                     twitter_icon_alpha = .8,
                     data_source = "NASA",
                     original = header$outfile,
                     crop = c(4500,4250),
                     crop_gravity = "east",
                     crop_start = NULL,
                     svg_file = NULL,
                     svg_coords = NULL,
                     svg_size = NULL,
                     inset = NULL,
                     inset_coords = c(.725, .3),
                     inset_size = 1000)
