
make_ellipse <- function(center_coords, 
                         r, 
                         height_factor = 1,
                         width_factor = 1,
                         npc, 
                         tilt = 0) {
  rad <- (tilt * pi) / 180

  tmp <- map_df(1:npc, function(i) {
    y1 <- r * sin((i * 180) / pi) * height_factor
    x1 <- r * cos((i * 180) / pi) * width_factor
    
    tibble(
      x = x1 * cos(rad) - y1 * sin(rad),
      y = y1 * cos(rad) + x1 * sin(rad)
    ) 
  }) 
  
  tmp |> 
    mutate(x = center_coords[1] + x,
           y = center_coords[2] + y) |> 
    st_as_sf(coords = c("y", "x"), crs = 4326) |>
    summarise() |>
    st_cast(to = "POLYGON") |>
    st_convex_hull()


}

# 
# make_ellipse(c(0,0), .5, 1000, -30) |> 
#   ggplot() +
#   geom_sf(data = spData::us_states) +
#   geom_sf(color = "red") +
#   coord_sf(crs = 2229)

