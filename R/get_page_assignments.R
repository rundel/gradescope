#' Get assigned pages for each question and subquestion for an assignment
#'
#' @param link - url of the question assignment page, e.g. those returned by assignment_links
#'
#' @export
#'

get_page_assignments = function(link) {
  usethis::ui_info("Checking {student}'s page assignments")

  session = hayalbaz::puppet$new(cookies = cookies)
  session$goto(link)
  session$wait_on_load()

  z = session$get_elements(".selectPagesQuestionOutline--item:not(.selectPagesQuestionOutline--item-unassignable)")

  get_node_text = function(xml2, selector) {
    rvest::html_nodes(xml2, selector) %>%
      rvest::html_text() %>%
      stringr::str_trim()
  }

  questions = purrr::map_chr(z, get_node_text, ".selectPagesQuestionOutline--title") %>%
    str_remove("^[0-9]\\.[0-9] ")
  pages = purrr::map(z, get_node_text, "button") %>% purrr::map(paste, collapse=", ")

  pages %>%
    setNames(questions) %>%
    c(link = link, .)
}
