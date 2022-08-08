# `add_main_annotations` will add title and caption to the 
# original graphic and save it to a new graphic. It also 
# normalizes coordinates to c(x,y) where c(0,0) is the upper left corner, 
# as opposed to the `magick` coordinate system. 

library(glue)
library(fontawesome)
library(grid)
library(svgparser)
library(scales)
library(magick)


add_main_annotations <- function(
    # original is the original graphic to be read in and annotated here
    original,
    pal, map, # used for naming output file
    text_color,
    # `align` currently only works with "center", but
    # eventually it can be built out to support other
    # values, which will translate to `magick` gravity.
    align = "center", 
    # base_coords are a vector of length 2 where the
    # first value is x and the second is y. Both values
    # should fall between 0 and 1.
    base_coords,
    # offset refers to offset of secondary title from
    # main title
    offset,
    # main title, usually larger and bold
    main_text,
    main_size,
    main_font,
    # secondary title is based on coords of main title,
    # but offset based on `offset`.
    secondary_text,
    secondary_size,
    secondary_font,
    # data_source is the attribution added to the caption
    data_source,
    # font size of caption
    caption_font,
    caption_size,
    # twitter icon might need dialing in
    # scaling of twitter icon
    twitter_icon_size = 75,
    # positioning of twitter icon
    twitter_icon_coords = c(-450, 65),
    crop) {
  
  # Read in file, get dimensions
  orig <- image_read(original)
  if (!is.null(crop)) {
    orig <- image_crop(orig, glue("{crop[1]}x{crop[2]}"), gravity = "center")
  }
  w <- image_info(orig)$width
  h <- image_info(orig)$height
  
  # Currently only accounting for center aligned text;
  # can be built out to support right or left align by
  # setting gravity to "east" or "west" and adjusting the
  # `coords` transformation.
  
  if (align == "center") {
    gravity <- "north"
    c <- round(w / 2)
    wx <- round(base_coords[1] * w - c)
    if (wx < 0) {
      magick_x <- glue("{wx}")
    } else {
      magick_x <- glue("+{wx}")
    }
    
    wy <- round(base_coords[2] * h)
    magick_y <- glue("+{wy}")
    magick_y2 <- glue("+{wy+offset}")
  }
  
  # Main Title
  img_ <- image_annotate(orig, text = main_text, weight = 700, 
                         font = main_font, 
                         location = glue("{magick_x}{magick_y}"),
                         color = text_color, size = main_size, gravity = gravity)
  
  # Secondary title
  img_ <- image_annotate(img_, text = secondary_text, font = secondary_font,
                         color = text_color, size = secondary_size, gravity = gravity,
                         location = glue("{magick_x}{magick_y2}"))
  
  # Twitter logo for caption
  # Get logo SVG, draw it, and then save to png
  
  twitter <- fa("twitter", fill = text_color, fill_opacity = .5)
  
  grid.newpage()
  tmp <- tempfile()
  png(tmp, bg = "transparent")
  grid.draw(read_svg(twitter))
  dev.off()
  
  tw <- image_read(tmp)
  tw <- image_scale(tw, glue("x{twitter_icon_size}"))
  
  # Caption
  img_ <- image_annotate(img_, glue("Graphic by Spencer Schien (     @MrPecners) | ", 
                                    "Data from {data_source}"), 
                         font = caption_font, location = "+0+50",
                         color = alpha(text_color, .5), size = caption_size, gravity = "south")
  
  # Twitter
  
  if (twitter_icon_coords[1] < 1) {
    tic_x <- glue("{twitter_icon_coords[1]}")
  } else {
    tic_x <- glue("+{twitter_icon_coords[1]}")
  }
  
  # Twitter icon coords y can only be positive
  tic_y <- glue("+{twitter_icon_coords[2]}")
  
  img_ <- image_composite(img_, tw, gravity = "south",
                          offset = glue("{tic_x}{tic_y}"))
  
  image_write(img_, glue("images/{map}/{map}_titled_{pal}_highres.png"))
  
  # This writes a second image of smaller size, useful if you want to post
  # to Instagram or Reddit where size limits are restricted.
  
  smimg <- image_scale(img_, "4000")
  image_write(smimg, glue("images/{map}/{map}_titled_{pal}_insta_small.png"))
  file.copy(from = glue("images/{map}/{map}_titled_{pal}_insta_small.png"),
            to = glue("tracked_graphics/{map}_titled_{pal}_insta_small.png"), 
            overwrite = TRUE)
}


