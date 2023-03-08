library(tidyverse)
library(magick)
library(glue)
library(colorspace)

# Load `header` list with needed data
header <- readRDS("R/portraits/texas/header.rds")
colors <- header$colors
swatchplot(colors)

text_color <- colors[1]

img <- image_read(header$outfile)


shadow <- "#a46d67"


img |> 
  image_crop(geometry = "7000x5000+0+0", gravity = "center") |> 
  image_write("images/texas/titled_tx_pop.png")

cap <- glue("Graphic by Spencer Schien (@MrPecners) | ",
            "Kontur Population Data (Released June 30, 2022)")

system(
   glue("magick -background None -virtual-pixel Transparent -fill '{colors[8]}' ",
        "-pointsize 300 -kerning 300 -font Marhey-Bold ",
        "label:TEXAS  -trim +repage ",
         "-gravity South -chop 0x5 ",
         "-flip +distort SRT '0,0 1,-1 0' \\( ",
         "+clone -background Black -shadow 30x25+0+0 ",
         "-virtual-pixel Transparent ",
         "+distort Affine '0,0 0,0  100,0 100,0  0,100 300,200' ",
         "\\) +swap -background transparent -layers merge ",
        
         "-fuzz 2% -trim -rotate -7 +repage images/texas/titled_tx_pop.png +swap ",
         "-geometry +250+3900 ",
        "-composite images/texas/titled_tx_pop_done.png")
 )

system(
  glue("magick -background None -virtual-pixel Transparent -fill '{colors[8]}' ",
       "-pointsize 100 -kerning 75 -font Marhey-Bold ",
       "label:'Population Density'  -trim +repage ",
       "-gravity South -chop 0x5 ",
       "-flip +distort SRT '0,0 1,-1 0' \\( ",
       "+clone -background Black -shadow 30x25+0+0 ",
       "-virtual-pixel Transparent ",
       "+distort Affine '0,0 0,0  100,0 100,0  0,100 300,200' ",
       "\\) +swap -background transparent -layers merge ",
       
       "-fuzz 2% -trim -rotate -7 +repage images/texas/titled_tx_pop_done.png +swap ",
       "-geometry +600+3650 ",
       "-composite images/texas/titled_tx_pop_done_pd.png")
)

system(
  glue("magick -background None -virtual-pixel Transparent -fill '{colors[8]}' ",
       "-pointsize 55 -kerning 20 -font Marhey ",
       "label:'{cap}'  -trim +repage ",
       "-gravity South -chop 0x5 ",
       "-flip +distort SRT '0,0 1,-1 0' \\( ",
       "+clone -background Black -shadow 20x5+0+0 ",
       "-virtual-pixel Transparent ",
       "+distort Affine '0,0 0,0  100,0 100,0  0,100 200,150' ",
       "\\) +swap -background transparent -layers merge ",
       
       "-fuzz 2% -trim +repage images/texas/titled_tx_pop_done_pd.png +swap ",
       "-geometry +0+100 ",
       "-composite images/texas/titled_tx_pop_done_cap.png")
)



image_read("images/texas/titled_tx_pop_done_cap.png") |> 
  image_scale(geometry = "58%x") |> 
  image_write("tracked_graphics/titled_tx_pop_small.png")

