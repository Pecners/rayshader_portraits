# Load packages and `add_main_annotations` function
for (f in list.files("R/utils")) {
  source(paste0("R/utils/", f, collapse = ""))
}

# Load `header` list with needed data
header <- readRDS("R/portraits/mount_katmai/header.rds")

# Take original graphic from `render_highquality` and
# add annotations.

add_main_annotations(map = header$map, pal = header$pal, 
                     text_color = header$colors[1], 
                     align = "center",
                     base_coords = c(.25, .2),
                     offset = -150,
                     main_text = "Mount Katmai",
                     main_size = 225,
                     main_font = "El Messiri",
                     secondary_text = "The Aleutian Mountain Range at",
                     secondary_size = 100,
                     secondary_font = "El Messiri",
                     tertiary_text = paste0("Graphic by Spencer Schien (    @MrPecners)\n",
                                            "Data from AWS Terrain Tiles"),
                     tertiary_size = 75,
                     tertiary_font = "El Messiri",
                     tertiary_offset = 500,
                     caption = FALSE,
                     twitter_icon_coords = c(-770, 2765),
                     twitter_icon_size = 55,
                     twitter_icon_alpha = .8,
                     data_source = "AWS Terrain Tiles",
                     original = header$outfile,
                     crop = c(4000, 4000),
                     crop_gravity = "center",
                     crop_start = c(-750, 0),
                     svg_file = NULL,
                     svg_coords = NULL,
                     svg_size = NULL,
                     inset = "images/mount_katmai/acadia_inset.png",
                     inset_coords = c(.25, .4),
                     inset_size = 1500)
