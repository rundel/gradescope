assignment_links = function() {
  session = hayalbaz::puppet$new(cookies = cookies)

  # Load assignment page
  session$goto(url)
  session$wait_on_load()

  links = c()
  ids = c()

  page = 1
  repeat {
    usethis::ui_done("Processing page {page}.")

    html = session$get_element("table") %>%
      rvest::html_nodes("a")

    links = c(links, rvest::html_attr(html, "href"))
    ids = c(ids, rvest::html_text(html))

    next_button = session$get_element(".submissionsManager--paginationContainer button:nth-of-type(2)", as_xml2 = FALSE)
    if (str_detect(next_button ,"disabled"))
      break

    session$focus(".submissionsManager--paginationContainer button:nth-of-type(2)")
    session$click(".submissionsManager--paginationContainer button:nth-of-type(2)")

    page = page + 1

    Sys.sleep(2)
  }

  tibble::tibble(
    student = ids,
    link = paste0(
      "https://www.gradescope.com",
      links,
      "/select_pages"
    )
  )
}
