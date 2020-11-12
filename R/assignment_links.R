#' Get links for page assignment
#'
#' @param url - url of the assignment on gradescope
#' @param cookies - list object containing login cookies for gradescope, obtained using `get_login_cookies`.
#'
#' @export
#'
assignment_links = function(url, cookies) {
  session = hayalbaz::puppet$new(cookies = cookies)

  # Load assignment page
  session$goto(url)
  session$wait_on_load()

  links = c()
  ids = c()

  page = 1
  repeat {
    usethis::ui_done("Processing page {page}.")

    html = session$get_element("table")
    html = rvest::html_nodes(html, "a")

    links = c(links, rvest::html_attr(html, "href"))
    ids = c(ids, rvest::html_text(html))

    next_button = try(
      session$get_element(".submissionsManager--paginationContainer button:nth-of-type(2)", as_xml2 = FALSE),
      silent = TRUE
    )
    if (inherits(next_button, "try-error") || stringr::str_detect(next_button ,"disabled"))
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
