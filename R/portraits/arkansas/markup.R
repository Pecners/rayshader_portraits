library(tidyverse)
library(magick)
library(glue)
library(colorspace)

# Load `header` list with needed data
header <- readRDS("R/portraits/arkansas/header.rds")
colors <- header$colors
swatchplot(colors)

text_color <- colors[1]

img <- image_read(header$outfile)


shadow <- "black"
  
cap <- glue("Graphic by Spencer Schien (@MrPecners) | ",
            "Kontur Population Data (Released June 30, 2022)")

img |> 
  image_crop(geometry = "7000x5750+0-250", gravity = "center") |> 
  image_write("images/arkansas/titled_ar_pop.png")


system(
  glue("magick -background None -virtual-pixel Transparent -fill '{colors[3]}' ",
       "-pointsize 300 -kerning 300 -font Marhey-Bold ",
       "label:ARKANSAS  -trim +repage ",
       "-gravity South -chop 0x5 ",
       "-flip +distort SRT '0,0 1,-1 0' \\( ",
       "+clone -background Black -shadow 30x25+0+0 ",
       "-virtual-pixel Transparent ",
       "+distort Affine '0,0 0,0  100,0 100,0  0,100 150,200' ",
       "\\) +swap -background transparent -layers merge ",
       "-fuzz 2% -trim +repage images/arkansas/titled_ar_pop.png +swap ",
       "-geometry +1000+5200 ",
       "-composite images/arkansas/titled_ar_pop_done.png")
)

system(
  glue("magick -background None -virtual-pixel Transparent -fill '{colors[3]}' ",
       "-pointsize 175 -kerning 125 -font Marhey-Bold ",
       "label:'Population Density'  -trim +repage ",
       "-gravity South -chop 0x5 ",
       "-flip +distort SRT '0,0 1,-1 0' \\( ",
       "+clone -background Black -shadow 30x25+0+0 ",
       "-virtual-pixel Transparent ",
       "+distort Affine '0,0 0,0  100,0 100,0  0,100 150,200' ",
       "\\) +swap -background transparent -layers merge ",
       
       "-fuzz 2% -trim +repage images/arkansas/titled_ar_pop_done.png +swap ",
       "-geometry +1000+4750 ",
       "-composite images/arkansas/titled_ar_pop_done_pd.png")
)

system(
  glue("magick -background None -virtual-pixel Transparent -fill '{colors[3]}' ",
       "-pointsize 55 -kerning 20 -font Marhey ",
       "label:'{cap}'  -trim +repage ",
       "-gravity South -chop 0x5 ",
       "-flip +distort SRT '0,0 1,-1 0' \\( ",
       "+clone -background Black -shadow 20x5+0+0 ",
       "-virtual-pixel Transparent ",
       "+distort Affine '0,0 0,0  100,0 100,0  0,100 200,150' ",
       "\\) +swap -background transparent -layers merge ",
       
       "-fuzz 2% -trim +repage images/arkansas/titled_ar_pop_done_pd.png +swap ",
       "-geometry +0+100 ",
       "-composite images/arkansas/titled_ar_pop_done_cap.png")
)



image_read("images/arkansas/titled_ar_pop_done_cap.png") |> 
  image_scale(geometry = "55%x") |> 
  image_write("tracked_graphics/titled_ar_pop_small.png")

