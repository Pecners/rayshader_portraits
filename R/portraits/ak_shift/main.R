library(tidyverse)
library(sf)
library(tigris)
library(rnaturalearth)
library(glue)
library(av)


s <- states() |> 
  st_as_sf()

skip <- c(
  "Puerto Rico",
  # "Alaska",
  # "Hawaii",
  "United States Virgin Islands",
  "Commonwealth of the Northern Mariana Islands",
  "American Samoa",
  "Guam"
)


skinny_s <- s |> 
  filter(!NAME %in% skip) 

skinny_s |> 
  as_tibble() |> 
  select(NAME) |> 
  write_csv("data/state_list.csv")


skinny_s |> 
  ggplot() +
  geom_sf()

l <- ne_download(type = "lakes", category = "physical", scale = "large")  %>%
  st_as_sf(., crs = st_crs(states))

lakes <- c("Lake Erie",
           "Lake Michigan",
           "Lake Superior",
           "Lake Huron",
           "Lake Ontario")

gl <- l %>%
  filter(name %in% lakes) %>%
  st_transform(crs = st_crs(skinny_s)) |> 
  st_union()

land <- ne_download(type = "land", category = "physical", scale = "large")  %>%
  st_as_sf() %>%
  st_transform(., crs = st_crs(skinny_s)) |> 
  st_union()


skinny_s <- st_difference(skinny_s, gl)

skinny_s <- st_intersection(skinny_s, land) |> 
  st_transform(crs = 2163)

skinny_cont <- skinny_s |> 
  filter(!NAME %in% c("Alaska", "Hawaii"))

skinny_s |> 
  filter(!NAME %in% c("Alaska", "Hawaii")) |> 
  ggplot() +
  geom_sf() +
  coord_sf(crs = 2163)

# alaska

ak <- skinny_s |> 
  filter(NAME == "Alaska")

shift_one <- function(d, movement_x = .1, movement_y = .1, tilt = 0) {
  
  tmp <- d |> 
    st_union() |> 
    st_centroid() |>
    st_coordinates() |> 
    as_tibble()
  
  bb <- st_bbox(d)
  width <- abs(abs(bb[["xmax"]]) - abs(bb[["xmin"]]))
  height <- abs(abs(bb[["ymax"]]) - abs(bb[["ymin"]]))
  
  # Convert degrees to radians
  rad <- (tilt * pi) / 180
  
  shifted <- d |>
    st_coordinates() |>
    as_tibble() |> 
    mutate(xc = X - tmp[[1,"X"]],
           yc = Y - tmp[[1, "Y"]],
           xf = xc * cos(rad) - yc * sin(rad),
           yf = yc * cos(rad) + xc * sin(rad),
           xx = xf + tmp[[1, "X"]] + width * movement_x,
           yy = yf + tmp[[1, "Y"]] + height * movement_y) |> 
    st_as_sf(coords = c("xx", "yy"), crs = st_crs(d)) |> 
    group_by(L2) |> 
    summarise(do_union = FALSE) |> 
    st_cast(to = "POLYGON") |> 
    rename(geom = geometry)
  
  f <- bind_cols(shifted, population = d$population)
  
  return(f)
}

new <- shift_one(ak, 1.05, -1.45, tilt = 30)

l <- 72

x_ind <- seq(from = 0, to = 1.05, length.out = l)
y_ind <- seq(from = 0, to = -1.45, length.out = l)
a_ind <- seq(from = 0, to = 30, length.out = l)

# this creates a frame that for the image
bg <- st_bbox(skinny_cont) |> 
  st_as_sfc(crs = st_crs(skinny_cont)) |> 
  st_buffer(950000)

# Shift ak down
walk(1:l, function(i) {
  new <- shift_one(ak, x_ind[i], y_ind[i], tilt = a_ind[i])
  
  
  p <- new |> 
    ggplot() +
    geom_sf(data = bg, color = NA, fill = NA) +
    geom_sf(data = skinny_cont, color = "grey50", fill = "grey90") +
    geom_sf(color = "#CB4335", fill = alpha("#CB4335", .75)) +
    theme_void() +
    theme(text = element_text(family = "Poller One",
                              color = "grey50",
                              hjust = .9)) +
    labs(caption = "Spencer Schien (@MrPecners)")
  
  ind <- as.numeric(i) |> 
    str_pad(width = 3, side = "left", pad = "0")
  
  ggsave(p, filename = glue("images/ak_shift/{ind}.png"), bg = "transparent",
         width = 16, height = 9)
  
  cat(crayon::cyan(glue("Finished {ind}"), "\n"))
  
})

# Spin ak
angles <- seq(from = 0, to = 360, by = 2)
m <- length(x_ind)
bb <- st_bbox(shift_one(ak, x_ind[72], y_ind[72], tilt = a_ind[72]))

walk(angles, function(i) {
  new <- shift_one(ak, x_ind[m], 
                   y_ind[m], 
                   tilt = 30 + i)
  
  
  p <- new |> 
    ggplot() +
    geom_sf(data = bg, color = NA, fill = NA) +
    geom_sf(data = skinny_cont, color = "grey50", fill = "grey90") +
    geom_sf(color = "#CB4335", fill = alpha("#CB4335", .75)) +
    theme_void() +
    theme(text = element_text(family = "Poller One",
                              color = "grey50",
                              hjust = .9)) +
    labs(caption = "Spencer Schien (@MrPecners)")
  
  mi <- m + i
  
  ind <- as.numeric(mi) |> 
    str_pad(width = 3, side = "left", pad = "0")
  
  ggsave(p, filename = glue("images/ak_shift/{ind}.png"), bg = "transparent",
         width = 16, height = 9)
  
  cat(crayon::cyan(glue("Finished {ind}"), "\n"))
  
})

# make_movie

f <- list.files("images/ak_shift")
ff <- paste("images/ak_shift/", f, sep = "")

vid <- av_encode_video(ff)
