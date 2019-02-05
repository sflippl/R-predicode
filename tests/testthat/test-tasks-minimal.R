context("test-tasks-minimal")

test_that("Weights are restricted to the correct values", {
  expect_error(
      minimal_task(x = cars, y = cars, w = 1)
  )
  expect_error(
      minimal_task(x = cars, y = cars, w = c(NA, 1))
  )
  expect_error(
      minimal_task(x = cars, y = cars, w = "a")
  )
  expect_error(
      minimal_task(x = cars, y = cars, w = c(-1, 1))
  )
  expect_error(
      minimal_task(x = cars, y = cars, w = c(Inf, 1))
  )
})

test_that("x and y are restricted", {
    expect_error(
        minimal_task(x = cars, y = 1)
    )
    expect_error(
        minimal_task(x = cars, y = cars[1:40, ])
    )
})

x <-
    cars %>%
    dplyr::transmute(speed = scale(speed))
y <-
    cars %>%
    dplyr::transmute(dist = scale(dist))
minimal_task_1 <- minimal_task(x, y)
minimal_task_1

test_that("Task elements are correctly recovered", {
    expect_equal(weights(minimal_task_1), 1L)
    expect_equal(input(minimal_task_1), x)
    expect_equal(output(minimal_task_1), y)
})

test_that("Task elements are correctly printed", {
    expect_output(print(minimal_task_1, "p = 1"))
})
