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
    
    tertiary_text = NULL,
    tertiary_size,
    tertiary_font,
    tertiary_offset,
    tertiary_weight = 400,
    
    # data_source is the attribution added to the caption
    data_source,
    # font size of caption
    caption_font,
    caption_size,
    caption_coords,
    caption_align,
    caption = TRUE,
    # twitter icon might need dialing in
    # scaling of twitter icon
    twitter_icon_size = 75,
    # positioning of twitter icon
    twitter_icon_coords = c(-450, 65),
    twitter_icon_alpha = .5,
    # use to add svg
    svg_file = NULL,
    svg_coords,
    svg_size,
    crop = NULL,
    crop_gravity = NULL,
    crop_start = NULL,
    inset,
    inset_coords,
    inset_size,
    small_size = 4000) {
  
  # Read in file, get dimensions
  if (is.character(original)) {
    orig <- image_read(original)
  } else {
    orig <- original
  }
  
  
  if (!is.null(crop_start)) {
    orig <- image_crop(orig, glue("{crop[1]}x{crop[2]}+{crop_start[1]}+{crop_start[2]}"),
                       gravity = crop_gravity)
  }
  if (!is.null(crop)) {
    orig <- image_crop(orig, glue("{crop[1]}x{crop[2]}"), gravity = crop_gravity)
  }
  w <- image_info(orig)$width
  h <- image_info(orig)$height
  
  # Currently only accounting for center aligned text;
  # can be built out to support right or left align by
  # setting gravity to "east" or "west" and adjusting the
  # `coords` transformation.
  
  # if (align == "center") {
  #   gravity <- "north"
  #   c <- round(w / 2)
  #   wx <- round(base_coords[1] * w - c)
  #   if (wx < 0) {
  #     magick_x <- glue("{wx}")
  #   } else {
  #     magick_x <- glue("+{wx}")
  #   }
  #   
  #   wy <- round(base_coords[2] * h)
  #   magick_y <- glue("+{wy}")
  #   magick_y2 <- glue("+{wy+offset}")
  # }
  main_loc <- normalize_coords(img = orig, coords = base_coords, align = align)
  
  # Main Title
  img_ <- image_annotate(orig, text = main_text, weight = 700, 
                         font = main_font, 
                         location = main_loc$loc_coords,
                         color = text_color, size = main_size, gravity = main_loc$gravity)
  cat(glue("Primary text: {main_loc$loc_coords}, {main_loc$gravity}"), "\n")
  
  # Secondary title
  if (!is.null(secondary_text) & nchar(secondary_text) > 0) {
    
    sec_loc <- normalize_coords(img = orig, coords = base_coords, align = align,
                                offset = offset)
    
    img_ <- image_annotate(img_, text = secondary_text, font = secondary_font,
                           color = text_color, size = secondary_size, 
                           gravity = sec_loc$gravity,
                           location = sec_loc$loc_coords)
    cat(glue("Secondary text: {sec_loc$loc_coords}, {sec_loc$gravity}"), "\n")
  }
  
  # Tertiary title
  if (!is.null(tertiary_text)) {
    if (nchar(tertiary_text) > 0) {
      
      ter_loc <- normalize_coords(img = orig, coords = base_coords, align = align,
                                  offset = offset + tertiary_offset)
      
      img_ <- image_annotate(img_, text = tertiary_text, font = tertiary_font,
                             weight = tertiary_weight,
                             color = text_color, size = tertiary_size, 
                             gravity = ter_loc$gravity,
                             location = ter_loc$loc_coords)
      cat(glue("Tertiary text: {ter_loc$loc_coords}, {ter_loc$gravity}"), "\n")
    }
  }

  # Twitter logo for caption
  # Get logo SVG, draw it, and then save to png
  
  twitter <- fa("twitter", fill = text_color, fill_opacity = twitter_icon_alpha)
  
  grid.newpage()
  tmp <- tempfile()
  png(tmp, bg = "transparent")
  grid.draw(read_svg(twitter))
  dev.off()
  
  tw <- image_read(tmp)
  tw <- image_scale(tw, glue("x{twitter_icon_size}"))
  
  # Caption
  
  if (caption) {
    cap_text <- glue("Graphic by Spencer Schien (     @MrPecners) | ", 
                     "Data from {data_source}")
    
    if (!is.null(caption_coords)) {
      cap_loc <- normalize_coords(img = orig, coords = caption_coords, align = caption_align)
      img_ <- image_annotate(img_, text = cap_text, font = caption_font,
                             color = alpha(text_color, .5), size = caption_size, 
                             gravity = cap_loc$gravity,
                             location = cap_loc$loc_coords)
      cat(glue("Caption text: {cap_loc$loc_coords}, {cap_loc$gravity}"), "\n")
    } else { 
      img_ <- image_annotate(img_, cap_text, 
                             font = caption_font, location = "+0+50",
                             color = alpha(text_color, .5), size = caption_size, gravity = "south")
    }
  }
  
  
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
  
  # Other SVG
  
  if (!is.null(svg_file)) {
    
    svg <- read_svg(svg_file)
    
    tmp <- tempfile()
    png(tmp, bg = "transparent")
    grid::grid.newpage()
    grid::grid.draw(svg)
    dev.off()
    
    svg_tmp <- image_read(tmp)
    svg_tmp <- image_scale(svg_tmp, glue("x{svg_size}"))
    
    gravity <- "north"
    c <- round(w / 2)
    svg_w <- round(svg_coords[1] * w - c)
    if (svg_w < 0) {
      svg_x <- glue("{svg_w}")
    } else {
      svg_x <- glue("+{svg_w}")
    }
    
    svg_h <- round(svg_coords[2] * h)
    svg_y <- glue("+{svg_h}")
    
    img_ <- image_composite(img_, svg_tmp, gravity = gravity,
                            offset = glue("{svg_x}{svg_y}"))
  }
  
  if (!is.null(inset)) {
    gravity <- "north"
    c <- round(w / 2)
    ins_w <- round(inset_coords[1] * w - c)
    if (ins_w < 0) {
      ins_x <- glue("{ins_w}")
    } else {
      ins_x <- glue("+{ins_w}")
    }
    
    ins_h <- round(inset_coords[2] * h)
    ins_y <- glue("+{ins_h}")
    
    inset <- image_read(inset)
    inset <- image_scale(inset, glue("x{inset_size}"))
    img_ <- image_composite(img_, inset, gravity = gravity,
                            offset = glue("{ins_x}{ins_y}"))
  }
  
  # Write main high res image
  image_write(img_, glue("images/{map}/{map}_titled_{pal}_highres.png"), format = "png")
  
  # This writes a second image of smaller size, useful if you want to post
  # to Instagram or Reddit where size limits are restricted.
  
  smimg <- image_scale(img_, small_size)
  image_write(smimg, glue("images/{map}/{map}_titled_{pal}_insta_small.png"), format = "png")
  file.copy(from = glue("images/{map}/{map}_titled_{pal}_insta_small.png"),
            to = glue("tracked_graphics/{map}_titled_{pal}_insta_small.png"), 
            overwrite = TRUE)
}


