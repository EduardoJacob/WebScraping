
GET_LYRICS = function(url) {
  message("Scraping: ", url) # Keeps you informed in the console
  
  rvest::read_html(url) |> 
    rvest::html_element("p.lyrics") |>    # Replace with the container of your text
    rvest::html_text2()
}

