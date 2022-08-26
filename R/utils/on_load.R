
.new_portrait <- function(map) {
  if (!dir.exists(glue::glue("R/portraits/{map}"))) {
    dir.create(glue::glue("R/portraits/{map}"))
  } else {
    stop(glue::glue("The directory R/portraits/{map} already exists!"))
  }
  
  files <- list.files("R/templates")
  for (f in files) {
    file.create(glue::glue("R/portraits/{map}/{f}"))
    readLines(glue::glue("R/templates/{f}")) |> 
      gsub("CONFIG_MAP", map, x = _) |> 
      writeLines(text = _, con = glue::glue("R/portraits/{map}/{f}"))
  }
  
  file.edit(glue::glue("R/portraits/{map}/render_graphic.R"))
  
}

cat(
  crayon::bold(
    crayon::cyan("Use `.new_portrait()` to start working on a new portrait.\n")
  )
)
