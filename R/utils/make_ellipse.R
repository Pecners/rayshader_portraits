
make_ellipse <- function(center_coords, r, npc, tilt) {
  rad <- (tilt * pi) / 180

  tmp <- map_df(1:npc, function(i) {
    y1 <- center_coords[2] + r * sin((i * 180) / pi) * .5
    x1 <- center_coords[1] + r * cos((i * 180) / pi)
    
    tibble(
      x = x1 * cos(rad) - y1 * sin(rad),
      y = y1 * cos(rad) + x1 * sin(rad)
    ) 
  }) 
  
  tmp |> 
    mutate(x = coords[1] + x,
           y = coords[2] + y) |> 
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

