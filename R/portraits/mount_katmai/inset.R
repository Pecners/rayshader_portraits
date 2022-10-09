library(geomtextpath)
library(svgparser)

# Compass rose SVG from here: https://freesvg.org/compass-rose-vector-sketch
# I edited the SVG file to change fill from black to the palette blue
rose <- read_svg("R/portraits/mount_katmai/CompassRose.svg")

tmp <- tempfile()
png(tmp, bg = "transparent")
grid::grid.newpage()
grid::grid.draw(rose)
dev.off()

svg_tmp <- image_read(tmp)
svg_tmp

f_image <- image_blank(width = image_info(svg_tmp)$width * 1.5, height = image_info(svg_tmp)$height * 1.5, color = "none") |> 
  image_composite(svg_tmp, operator = "plus", gravity = "center") |> 
  image_annotate(gravity = "north", text = "N", font = "El Messiri", size = 100, weight = 700,
                 color = header$colors[1]) |> 
  image_background(color = "none") |> 
  image_rotate(-65)

f_image


image_write(f_image, glue("images/{header$map}/{header$pal}_inset.png"))
