

height_shade2 <- function (heightmap, 
                           heightmap2 = NULL,
                           texture1, 
                           texture2, 
                           split, 
                           keep_user_par = TRUE) 
{
  
  t1 <- texture1
  t2 <- texture2
  
  if (!is.null(heightmap2)) {
    # Sea level and above
    
    tempfilename = tempfile()
    
    grDevices::png(tempfilename, width = nrow(heightmap), height = ncol(heightmap))
    graphics::par(mar = c(0, 0, 0, 0))
    graphics::image(rayshader:::fliplr(heightmap), axes = FALSE, col = t1, 
                    useRaster = TRUE)
    graphics::image(rayshader:::fliplr(heightmap2), axes = FALSE, col = t2, 
                    useRaster = TRUE, add = TRUE)
    grDevices::dev.off()
    tempmap = png::readPNG(tempfilename)
  } else {
    range1 <- c(min(heightmap, na.rm = TRUE), split)
    range2 <- c(split, max(heightmap, na.rm = TRUE))
    
    # Sea level and above
    
    tempfilename = tempfile()
    
    grDevices::png(tempfilename, width = nrow(heightmap), height = ncol(heightmap))
    graphics::par(mar = c(0, 0, 0, 0))
    graphics::image(rayshader:::fliplr(heightmap), axes = FALSE, col = t1, 
                    useRaster = TRUE, zlim = range1)
    graphics::image(rayshader:::fliplr(heightmap), axes = FALSE, col = t2, 
                    useRaster = TRUE, zlim = range2, add = TRUE)
    grDevices::dev.off()
    tempmap = png::readPNG(tempfilename)
  }
  
  return(tempmap)
}
