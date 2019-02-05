context("test-fnn-minimal")

test_that("Minimal FNN checks wrong inputs", {
  expect_error(minimal_fnn(matrix("a"), matrix("a")))
  expect_error(minimal_fnn(matrix(c(1, 2), nrow = 1),
                           matrix(c(1, 2), nrow = 1)))
  expect_error(minimal_fnn(matrix(1, nrow = 1), "a"))
})

minimal_fnn_manual <-
    minimal_fnn(theta_0 = matrix(-1), theta_1 = matrix(-1))

test_that("FNN elements are correctly recovered", {
    expect_equal(theta_0(minimal_fnn_manual), matrix(-1))
    expect_equal(theta_1(minimal_fnn_manual), matrix(-1))
})

test_that("FNN dimensions are correctly recovered", {
    expect_equal(dim(minimal_fnn_manual), c(p = 1, q = 1, r = 1))
})
