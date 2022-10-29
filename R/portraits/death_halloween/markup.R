# Load packages and `add_main_annotations` function
for (f in list.files("R/utils")) {
  source(paste0("R/utils/", f, collapse = ""))
}

# Load `header` list with needed data
header <- readRDS("R/portraits/death_halloween/header.rds")

colorspace::swatchplot(header$colors)

# Take original graphic from `render_highquality` and
# add annotations.

add_main_annotations(map = header$map, pal = header$pal, 
                     text_color = header$colors[3], 
                     align = "center",
                     base_coords = c(.65, .065),
                     offset = 400,
                     main_text = "Death Valley",
                     main_size = 250,
                     main_font = "Nosifer",
                     secondary_text = "National  Park",
                     secondary_size = 200,
                     secondary_font = "Rock Salt",
                     caption_size = 50,
                     caption_font = "Rock Salt",
                     caption_coords = c(.5, .96),
                     caption_align = "center",
                     twitter_icon_coords = c(-840, 120),
                     twitter_icon_size = 60,
                     data_source = "USGS and AWS Terrain Tiles via the elevatr R package",
                     original = header$outfile,
                     crop = c(5000, 5250),
                     crop_gravity = "southeast",
                     crop_start = c(0, 500),
                     svg_file = NULL,
                     svg_coords = NULL,
                     svg_size = NULL,
                     inset = NULL,
                     inset_coords = c(.725, .3),
                     inset_size = 1000)
