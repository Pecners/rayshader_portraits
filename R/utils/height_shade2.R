

height_shade2 <- function (heightmap, texture1, texture2, split, keep_user_par = TRUE) 
{
  
  t1 <- t1
  t2 <- t2

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
  
  return(tempmap)
}
