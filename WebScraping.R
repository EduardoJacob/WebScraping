
# set snippet ----
# usethis::edit_rstudio_snippets()
# Ctrl+Shift-P - Show Command Palette
rstudiotools::setcwd()
try( dev.off(dev.list()["RStudioGD"]),silent=T) # Clear Plots
rm(list=ls()) # Clear Workspace
gc()
cat("\014") # Clear Console ctrl+L
xfunctions::XLibrary("rvest")
# xfunctions::XFunctions("rvest")
help(package="rvest")
packageDescription("rvest")
# devtools::install_github("author_name/rvest", build_vignettes = TRUE, dependencies = TRUE)
# browseVignettes(package="rvest")
# vignette(package="rvest")
# vignette("vignette-name",package="rvest")
# https://cranlogs.r-pkg.org/badges/last-month/rvest
rstudiotools::showinfo()

source("WebScrapingFunctions.R")

URL = "https://joannanewsomlyrics.com/"

main_page = rvest::read_html(URL)

nodes = main_page |> rvest::html_elements("a")

# 2. Extract both link and text 
links = data.frame(
  link = nodes |> rvest::html_attr("href") |> rvest::url_absolute(URL),
  text = nodes |> rvest::html_text2()
)

# Build Dataframe ----
musics = data.frame( 
  link = character(), 
  album_type = character(),
  album_number = integer(),
  album_name = character(),
  absolute_track_number = integer(),
  relative_track_number = integer(),
  track_name = character(),
  lyrics = character()
)

# i = 75
previous_album_name = ""

i = 3
for ( i in 1:nrow(links) ) {
  link = links$link[i]
  original_link = link
  text = links$text[i]
  if ( !stringr::str_detect(link, "/album/|/unreleased/") ) next
  
  # https://joannanewsomlyrics.com/album/10-divers/65-time-as-a-symptom/
  # https://joannanewsomlyrics.com/unreleased/66-make-hay/
  link = stringr::str_replace(link,"unreleased","unreleased/99-unreleased")
  
  parts = unlist( stringr::str_split(link, "/") )
  if ( length(parts) != 7 ) next
  
  album_type = parts[4]
  album_number = as.integer( stringr::str_extract(parts[5], "^[0-9]+") )
  album_name = parts[5] |>
    stringr::str_remove("^[0-9]+-") |>
    stringr::str_replace_all("-", " ") |>
    stringr::str_to_title()
  
  if ( album_name != previous_album_name ) {
    previous_album_name = album_name
    relative_track_number = 0
  } 
  
  relative_track_number = relative_track_number + 1
  
  absolute_track_number = as.integer( stringr::str_extract(parts[6], "^[0-9]+") )
  track_name = parts[6] |>
    stringr::str_remove("^[0-9]+-") |>
    stringr::str_replace_all("-", " ") |>
    stringr::str_to_title()

  df = data.frame( 
    link = original_link, 
    album_type = album_type,
    album_number = album_number,
    album_name = album_name,
    absolute_track_number = absolute_track_number,
    relative_track_number = relative_track_number,
    track_name = text,
    lyrics = GET_LYRICS(original_link)
  )
  
  musics = rbind(musics,df)  
}

 
# Save
# saveRDS(musics,file = "musics.rds")
# Restore
# musics = readRDS("musics.rds")

report = data.frame(
  Title = paste0(musics$album_name," - ",as.character(musics$relative_track_number)," - ",musics$track_name) ,
  Lyrics = musics$lyrics
)

saveRDS(report,file = "Report.rds")



