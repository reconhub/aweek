# Determine when things should do the thing
build       <- Sys.getenv("BUILD_PKGDOWN") != ""
ssh_enabled <- Sys.getenv("id_rsa") != "" 
codecov     <- Sys.getenv("R_CODECOV") != ""
is_master   <- ci$get_branch() == "master"
not_a_tag   <- !ci$is_tag() 

# check/build arguments
repos       <- getOption("repos")
check_args  <- c("--as-cran", "--timings")
build_args  <- c("--force", "--resave-data", "--compact-vignettes=gs+qpdf")


get_stage("install") %>%
  add_step(step_install_deps(repos = repos)

get_stage("script") %>%
  add_step(step_rcmdcheck(warnings_are_errors = NULL,
                          notes_are_errors = FALSE,
                          args = check_args,
                          build_args = build_args,
                          error_on = "warning",
                          repos = repos,
                          timeout = Inf))

if (codecov) {
  get_stage("after_success") %>%
    add_code_step(covr::codecov(quiet = FALSE))
}


if (ssh_enabled && build && is_master && not_a_tag) {
  # pkgdown documentation can be built optionally. Other example criteria:
  # - `inherits(ci(), "TravisCI")`: Only for Travis CI
  # - `Sys.getenv("BUILD_PKGDOWN") != ""`: If the env var "BUILD_PKGDOWN" is set
  # - `Sys.getenv("TRAVIS_EVENT_TYPE") == "cron"`: Only for Travis cron jobs
  get_stage("before_deploy") %>%
    add_step(step_setup_ssh())

  get_stage("deploy") %>%
    add_step(step_build_pkgdown()) %>%
    add_step(step_push_deploy(path = "docs", branch = "gh-pages"))
}
