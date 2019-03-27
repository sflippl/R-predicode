context("test-stopping_rule")

test_that("Instantiation only works for proper values", {
  expect_error(stopping_rule(max_iterations = 5, stopping_distance = -1))
  expect_error(stopping_rule(max_iterations = Inf, stopping_distance = 0))
  expect_error(stopping_rule(max_iterations = 5.5, stopping_distance = 1))
  expect_error(stopping_rule(max_iterations = 5, stopping_distance = "a"))
})

stopping_rule <- stopping_rule(max_iterations = 1000, stopping_distance = 1e-6)

test_that("Attributes may be recovered", {
    expect_equal(max_iterations(stopping_rule), 1000)
    expect_equal(stopping_distance(stopping_rule), 1e-6)
})

test_that("Stopping rule prints correctly", {
    expect_output(
        print(stopping_rule),
        glue::glue(
            "Stopping rule: Stop if:",
            "\n               iterations > 1000 or",
            "\n               distance between the last two elements < 1e-06.",
            .trim = FALSE)
    )
    expect_output(
        print(stopping_rule(Inf, 1e-6)),
        glue::glue(
            "Stopping rule: Stop if:",
            "\n               distance between the last two elements < 1e-06.",
            .trim = FALSE)
    )
    expect_output(
        print(stopping_rule(1000, 0)),
        glue::glue(
            "Stopping rule: Stop if:",
            "\n               iterations > 1000",
            .trim = FALSE)
    )
})
