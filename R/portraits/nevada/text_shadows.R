system(
  glue("magick -background None -virtual-pixel Transparent -fill '{colors[1]}' ",
       "-pointsize 300 -kerning 300 -font Marhey-Bold ",
       "label:NEVADA  -trim +repage ",
       "-gravity South -chop 0x5 ",
       "-flip +distort SRT '0,0 1,-1 0' \\( ",
       "+clone -virtual-pixel Transparent ",
       "+distort Perspective '0,0 0,0  100,0 100,0   0,-100 -1,-100   100,-100 100,-100' ",
       "-fuzz 2% -trim -background '{shadow}' -shadow 60x15+0+0 ",
       "+distort Perspective '0,0 0,0  100,0 100,0  0,50 20,150' ",
       "\\) +swap -background transparent -layers merge ",
       "-fuzz 2% -trim -rotate 7 +repage images/nevada/titled_nv_pop.png +swap ",
       "-geometry +400+7200 ",
       "-composite images/nevada/titled_nv_pop_done.png")
)

system(
  glue("magick -background None -virtual-pixel Transparent -fill '{colors[1]}' ",
       "-pointsize 150 -kerning 75 -font Marhey-Bold ",
       "label:'Population Density'  -trim +repage ",
       "-gravity South -chop 0x5 ",
       "-flip +distort SRT '0,0 1,-1 0' \\( ",
       "+clone -virtual-pixel Transparent ",
       "+distort Perspective '0,0 0,0  100,0 100,0   0,-100 -1,-100   100,-100 100,-100' ",
       "-fuzz 2% -trim -background '{shadow}' -shadow 60x15+0+0 ",
       "+distort Perspective '0,0 0,0  100,0 100,0  0,50 20,100' ",
       "\\) +swap -background transparent -layers merge ",
       
       "-fuzz 2% -trim -rotate 7 +repage images/nevada/titled_nv_pop_done.png +swap ",
       "-geometry +300+6800 ",
       "-composite images/nevada/titled_nv_pop_done_pd.png")
)