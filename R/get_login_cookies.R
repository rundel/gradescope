get_login_cookies = function() {

  usethis::ui_info("Connecting to gradescope")

  session = hayalbaz::puppet$new()
  session$goto("https://www.gradescope.com/")

  session$wait_for_selector(".js-logInButton")
  session$click(".js-logInButton")

  session$wait_for_selector('input[type="submit", name="commit"]')

  usethis::ui_info(c(
    "Please log into gradescope using your prefered authentication method",
    "- your creditials will not be saved in any way, but your authentication",
    "token / cookies will be"
  ) )
  session$view()

  login_fail = usethis::ui_nope("Have you successfully logged into gradescope?",
                                yes = "Yes", no = "No", shuffle = FALSE)

  if (login_fail) {
    usethis::ui_stop("Login attempt failed - unable to retrieve necessary cookies / auth token")
  }

  invisible(
    session$get_cookies()
  )
}
