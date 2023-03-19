library(tidyverse)
library(magick)
library(glue)
library(colorspace)

# Load `header` list with needed data
header <- readRDS("R/portraits/tx_cities/header.rds")
colors <- header$colors
swatchplot(colors)

text_color <- colors[1]

img <- image_read(header$outfile)


shadow <- "#a46d67"
  
cap <- glue("Graphic by Spencer Schien (@MrPecners) | ",
            "Kontur Population Data (Released June 30, 2022)")

img |> 
  image_crop(geometry = "7000x6000+250-500", gravity = "center") |> 
  image_write("images/tx_cities/titled_tx_cities_pop.png")

darken('#1e181e', .75)
'black'
"#130313"

# Add "TEXAS CITIES"
system(
  glue("magick -background None -virtual-pixel Transparent -fill '{colors[8]}' ",
       "-pointsize 300 -kerning 200 -font Marhey-Bold ",
       "label:'TEXAS CITIES' -trim +repage ",
       "-gravity South -chop 0x5 ",
       "-flip +distort SRT '0,0 1,-1 0' \\( ",
       "-clone 0 -background Black -shadow 30x25+0+0 ",
       "-virtual-pixel Transparent ",
       "+distort Affine '0,0 0,0  100,0 100,0  0,100 100,200' \\) ",
       "+swap -background transparent ",
       "\\( -clone 0 -background Black -shadow 30x5+0+0 ",
       "-virtual-pixel Transparent ",
       "+distort Affine '0,0 0,0  100,0 100,0  0,100 -35,100' \\) ",
       " +swap -background transparent -layers merge  ",
       
       
       "-fuzz 2% -trim +repage images/tx_cities/titled_tx_cities_pop.png +swap ",
       "-geometry +500+5300 ",
       "-composite images/tx_cities/titled_tx_cities_pop_done.png")
)

# Add "Population Density"
system(
  glue("magick -background None -virtual-pixel Transparent -fill '{colors[8]}' ",
       "-pointsize 150 -kerning 125 -font Marhey-Bold ",
       "label:'Population Density'  -trim +repage ",
       "-gravity South -chop 0x5 ",
       "-flip +distort SRT '0,0 1,-1 0' \\( ",
       "+clone -background Black -shadow 30x25+0+0 ",
       "-virtual-pixel Transparent ",
       "+distort Affine '0,0 0,0  100,0 100,0  0,100 100,200' ",
       "\\) +swap -background transparent -layers merge ",
       
       "-fuzz 2% -trim +repage images/tx_cities/titled_tx_cities_pop_done.png +swap ",
       "-geometry +500+4800 ",
       "-composite images/tx_cities/titled_tx_cities_pop_done_one.png")
)

# Add Dallas and Houston
system(
  glue("convert -size 7000x6000 xc:none ",
       # Shadows
       "-gravity south -font Marhey-Bold -fill '{colors[8]}' ",
       "-pointsize 100 -kerning 75 ",
       # "-annotate -2600+2900 'Dallas' ",
       # "-background none ",
       # "-kerning 100 -annotate +190+620 'Houston' ",
       # "-background none ",
       # "-kerning 50 -annotate +190+1120 'San Antonio' ",
       # "-background none -blur 50x30 +repage ",
       
       # Foreground font
       "-annotate -45x-10-2900+4000 'Dallas' ", 
       "-annotate 25x0+2500+3650 'Houston' ", 
       # "-rotate 180 -distort arc '3 180' ",
       "-gravity north -pointsize 65 ",
       "images/tx_cities/titled_tx_cities_pop_done_one.png +swap ",
       "-composite images/tx_cities/titled_tx_cities_pop_done_two.png")
)

# Add arced San Antonio

system(
  glue("convert ",
    # Shadows
    "-font Marhey-Bold -fill '{colors[8]}' -background none ",
    "-pointsize 100 -kerning 75 ",
    # Foreground font
    "label:'San Antonio' ",
    "-distort arc '100' ",
    "-trim +repage images/tx_cities/titled_tx_cities_pop_done_two.png +swap ",
    "-gravity south -geometry -1250+2450 ",
    "-composite images/tx_cities/titled_tx_cities_pop_done_done.png"
  )
)

# Add caption
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
       
       "-fuzz 2% -trim +repage images/tx_cities/titled_tx_cities_pop_done_done.png +swap ",
       "-geometry +0+100 ",
       "-composite images/tx_cities/titled_tx_cities_pop_done_cap.png")
)

# make smaller graphic

image_read("images/tx_cities/titled_tx_cities_pop_done_cap.png") |> 
  image_scale(geometry = "60%x") |> 
  image_write("tracked_graphics/titled_tx_cities_pop_small.png")
