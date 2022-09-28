library(sf)
library(tidyverse)
library(elevatr)
library(rayshader)
library(glue)
library(NatParksPalettes)
library(packcircles)
library(patchwork)
library(magick)
library(scales)


# Set map name that will be used in file names, and 
# to get get boundaries from master NPS list

# https://irma.nps.gov/DataStore/Reference/Profile/2225713

data <- st_read("data/nps_boundary/nps_boundary.shp") 

sf_use_s2(FALSE)

# Filter for national parks

parks <- data |> 
  filter(UNIT_TYPE == "National Park") 


# Calculate area for each park 

areas <- map_dbl(1:nrow(parks), function(i) {
  st_area(parks[i,])
})

# Combine back with data, calculate summary

state_areas <- bind_cols(parks, area = areas) |> 
  as_tibble() |> 
  group_by(STATE) |> 
  summarise(total = sum(area),
            other = sum(Shape_Area),
            n = n()) |> 
  arrange(desc(total))

# Alaska ceiling clamp

alaska <- state_areas |> 
  filter(STATE == "AK") |> 
  pull(total) / 2.59e+6

# Join and fix territories.

state_names <- left_join(state_areas, 
                         tibble(
  STATE = state.abb,
  name = state.name)) |> 
    mutate(name = case_when(STATE == "VI" ~ "Virgin Islands",
                            STATE == "SA" ~ "American Samoa",
                            TRUE ~ name))

# Create plots
# I dialed in the range of scales to best suit the video

walk(c((1:625)^4+3e7), function(i) {
  
  # This code chunk clamps the high scale to Alaska when it's present
  if (alaska < (i / 2.59e+6)) {
    print("YES")
    high <- alaska
  } else {
    high <- i / 2.59e+6
  }
  
  # plot 
  
  p <- state_names |> 
    ggplot(aes(reorder(name, total), total / 2.59e+6)) +
    geom_col(fill = "#465727") +
    coord_flip(clip = "off", ylim = c(0, i / 2.59e+6)) +
    scale_y_continuous(breaks = c(0, high),
                       labels = c(0,
                                  paste0(label_comma()(high), " SQ MI"))) +
    theme_minimal() +
    theme(panel.grid.minor = element_blank(),
          panel.grid.major.y = element_blank(),
          plot.title.position = "plot",
          plot.caption = element_text(color = "grey70", size = 8),
          text = element_text(family = "Denk One", size = 12),
          axis.text.x = element_text(hjust = c(.5, 1))) +
    labs(title = "US National Park land area by state or territory",
         x = "", y = "",
         caption = "Analysis and graphic by Spencer Schien (@MrPecners) | Data from USGS") 

  ggsave(p, filename = glue("park_plots/{i}.png"), width = 8, height = 6,
         bg = "white")
  cat(crayon::cyan(i), "\n")
})

# Vector of plots
imgs <- paste("park_plots", list.files("park_plots"), sep  = "/")

# Create dataframe so we can arrange files appropriately
imgs_df <- tibble(imgs) |> 
  mutate(num = as.numeric(str_extract(imgs, "(?<=/).*(?=\\.png)"))) |> 
  arrange(num) 

nr <- nrow(imgs_df)

# expand vector of images to weight early areas
all <- bind_rows(imgs_df, imgs_df[c(1:floor(nrow(imgs_df)*.25)),]) |> 
  bind_rows(imgs_df[c(1:floor(nrow(imgs_df)*.1)),]) |> 
  arrange(num)

# First and last images so we can repeat them and create a "pause" in vid
first <- all[[1,1]]
final <- all[[nrow(all), 1]]

# create video
av::av_encode_video(c(all$imgs, rep(final, 120)), framerate = 40)

