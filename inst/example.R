library(gradescope)
library(tidyverse)
library(fs)

# Get cookies needed for authentication - this only needs to be done once
# the cookies object can then be saved as an rds and loaded when needed.
cookies = gradescope::get_login_cookies()
#cookies = readRDS("cookies.rds")


# Course assignment submission url
# Expected to be created as follows:
# Create Assignment > Exam / Quiz > Student Upload > Variable Length
# (other options including the template don’t matter)
#
# Course roster also needs to be created

url = "https://www.gradescope.com/courses/208281/assignments/840289/submissions"

file_dir = system.file("sample_pdfs", package = "gradescope")


# Get file paths
pdfs = fs::dir_ls(file_dir, glob = "*.pdf")

student_ids = stringr::str_match(pdfs, "(B[0-9]+)\\.pdf")[,2]



res = purrr::map2(
  student_ids, pdfs,
  ~ try(
      gradescope::upload_assignment(url = url, cookies = cookies, student = .x, file = .y),
      silent = FALSE
    )
)




gradescope::assignment_links(url = url, cookies = cookies)
