#' This function returns a tibble with the ellipse polygon defined.
#' 
#' @param center_coords are the spacial coordinates that will become the center
#' of the ellipse. Coordinates should be in EPSG:4326.
#' 
#' @param r is the radius of the ellipse in units of the CRS
#' 
#' @param height_factor ratio if the height radius compared to the width
#' @param width_factor ratio of the width radius compared to the height
#' 
#' @param npc number of control points for the ellipse
#' 
#' @param tilt is the angle of the ellipse in degrees. A value of 0 will results in 
#' the ellipse oriented so height is straight up along the north-south plane,
#' and width is flat along the east-west plane.
#' 
#' @param crs_transform transforms the coordinates to a designated CRS
#' using `sf::st_transform()`.
#'

make_ellipse <- function(center_coords, 
                         r, 
                         height_factor = 1,
                         width_factor = 1,
                         npc, 
                         tilt = 0,
                         crs_transform) {
  
  # Convert the center_coords to sf object
  transformed_coords <- tibble(
    x = center_coords[1],
    y = center_coords[2]
    ) |> 
    st_as_sf(coords = c("y", "x"), crs = 4326) |> 
    st_transform(crs = crs_transform)
  
  # Convert degrees to radians
  rad <- (tilt * pi) / 180

  # calculate points that will define the outline of the ellipse, 
  # centered at 0,0.
  tmp <- map_df(1:npc, function(i) {
    # these two lines have the ellipse orienting straight
    y1 <- r * sin((i * 180) / pi) * height_factor
    x1 <- r * cos((i * 180) / pi) * width_factor
    
    # This rotates the ellipse to the specified `tilt`
    tibble(
      x = x1 * cos(rad) - y1 * sin(rad),
      y = y1 * cos(rad) + x1 * sin(rad)
    ) 
  }) 
  
  # Points are currently centered at 0,0, so we need to shift to 
  # the `center_coords` location. Also convert points to polygon.
  tmp |> 
    mutate(x = st_bbox(transformed_coords)[2] + x,
           y = st_bbox(transformed_coords)[1] + y) |> 
    st_as_sf(coords = c("y", "x"), crs = crs_transform) |>
    summarise() |>
    st_cast(to = "POLYGON") |>
    st_convex_hull()

}

