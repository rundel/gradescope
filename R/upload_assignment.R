upload_assignment = function(student, file) {
  session = hayalbaz::puppet$new(cookies = cookies)

  usethis::ui_info("Uploading {file} for student {student}")

  # Load assignment page
  session$goto(url)
  session$wait_on_load()
  usethis::ui_done("Assignment page loaded")

  # Click uplaod button
  session$wait_for_selector(".fa-upload")
  session$click(".fa-upload")

  # Enter student name details
  session$wait_for_selector("#owner_id-selectized", timeout = 60)
  session$type("#owner_id-selectized", student)

  # Click selectize selection
  session$wait_for_selector(".selectize-dropdown-content", timeout = 60)
  session$click(".selectize-dropdown-content .option.active")

  # Attach file
  session$attach_file("#assignment_submission_pdf_attachment", file)

  # Click submit
  session$click("#submit")
  usethis::ui_done("File submitted")


  # Wait for page selection interface to load
  session$wait_on_load()
  usethis::ui_done("Submission page loaded")

  session$wait_for_selector(".pageThumbnail--selector", timeout = 60)
  usethis::ui_done("Page select interface loaded")

  # Click submit and then modal submit
  session$click(".fa-upload")
  session$click('button.modal--btnSecondary[type="submit"]')

  usethis::ui_done("Assignment submission completed")
  session$close()
}



