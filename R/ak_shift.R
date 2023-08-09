library(tidyverse)
library(scales)
library(ggtext)
library(glue)

ak_grouped <- state_areas |> 
  mutate(is_ak = ifelse(state == "Alaska", TRUE, FALSE)) |> 
  group_by(is_ak) |> 
  summarise(total = sum(total))

ak_high <- ak_grouped |> 
  pull(total) / 2.59e+6


ak_grouped |> 
  mutate(gname = ifelse(is_ak, 
                        glue("<span style='color:#EA3F3F'>Parks in Alaska</span>"), 
                        "All other parks")) |> 
  ggplot(aes(reorder(gname, -total), total / 2.59e+6, 
             fill = ifelse(is_ak, "#EA3F3F", "grey50"))) +
  geom_col(width = .75) +
  scale_fill_identity() +
  scale_y_continuous(breaks = c(0, ak_high),
                     labels = c(0, label_comma()(ak_high[1]),
                                paste0(label_comma()(ak_high[2]), " SQ MI"))) +
  theme_minimal() +
  theme(panel.grid.minor = element_blank(),
        panel.grid.major.x = element_blank(),
        plot.title.position = "plot",
        plot.caption.position = "plot",
        plot.title = element_textbox(size = 36, hjust = .5, lineheight = 1.2,
                                     halign = .5,
                                     margin = margin(t = 20, b = 30)),
        plot.caption = element_text(color = "grey70", size = 12),
        plot.margin = margin(rep(20, 4)),
        text = element_text(family = "Denk One", size = 20),
        axis.text.x = element_markdown(size = 30)) +
  labs(x = "", y = "",
       title = glue("<span style='color:#EA3F3F'>Alaska</span> ",
                    "has more National Park land<br>than all other states combined"),
       caption = "Analysis and graphic by Spencer Schien (@MrPecners) | Data from USGS")

ggsave(filename = "images/park_plots_tt/ak_against_others.png", width = 9, height = 12,
       bg = "white")
