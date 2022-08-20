normalize_coords <- function(img,
                             coords, 
                             align = "center",
                             offset = NULL) {
  w <- image_info(img)$width
  h <- image_info(img)$height
  
  if (align %in% c("center", "c")) {
    gravity <- "north"
    c <- round(w / 2)
    wx <- round(coords[1] * w - c)
    if (wx < 0) {
      magick_x <- glue("{wx}")
    } else {
      magick_x <- glue("+{wx}")
    }
    
    wy <- round(coords[2] * h)
    if (!is.null(offset)) {
      wy <- wy + offset
    }
    magick_y <- glue("+{wy}")
  }
  
  if (align %in% c("left", "l")) {
    gravity <- "west"
    wx <- round(coords[1] * w)
    magick_x <- glue("+{wx}")
    
    c <- round(h / 2)
    wy <- round(coords[2] * h - c)
    if (!is.null(offset)) {
      wy <- wy + offset
    }
    if (wy < 0) {
      magick_y <- glue("{wy}")
    } else {
      magick_y <- glue("+{wy}")
    }
  }
  
  if (align %in% c("right", "r")) {
    gravity <- "east"
    wx <- w - round(coords[1] * w)
    magick_x <- glue("+{wx}")
    
    c <- round(h / 2)
    wy <- round(coords[2] * h - c)
    if (!is.null(offset)) {
      wy <- wy + offset
    }
    if (wy < 0) {
      magick_y <- glue("{wy}")
    } else {
      magick_y <- glue("+{wy}")
    }
  }
  
  return(list(
    gravity = gravity,
    loc_coords = glue("{magick_x}{magick_y}"))
  )
}
