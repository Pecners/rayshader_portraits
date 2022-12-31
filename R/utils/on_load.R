
# Functions starting with '.' won't show up in the environment window
# but will be available in the GLOBALENV
.new_portrait <- function(map, 
                          template = NULL,
                          open_editor = TRUE) {
  
  if (is.null(template)) {
    files <- list.files("R/templates/elevation")
    subdir <- "elevation"
  } else if (template == "elevation") {
    files <- list.files("R/templates/elevation")
    subdir <- "elevation"
  } else if (template == "population") {
    files <- list.files("R/templates/population")
    subdir <- "population"
  } else {
    stop("`template` must be one of 'elevation' or 'population'!")
  }
  
  new_dir <- glue::glue("R/portraits/{map}")
  
  if (!dir.exists(new_dir)) {
    dir.create(new_dir)
  } else {
    stop(glue::glue("The directory {new_dir} already exists!"))
  }
  
  for (f in files) {
    new_file <- glue::glue("{new_dir}/{f}")
    file.create(new_file)
    readLines(glue::glue("R/templates/{subdir}/{f}")) |> 
      gsub("CONFIG_MAP", map, x = _) |> 
      writeLines(text = _, con = new_file)
  }
  
  # This will open a specified file in the editor pane
  if (open_editor) {
    file.edit(glue::glue("{new_dir}/render_graphic.R"))
  }
}

cat(
  crayon::bold(
    crayon::cyan("Use `.new_portrait()` to start working on a new portrait.\n")
  )
)
