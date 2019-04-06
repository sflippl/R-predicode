
<!-- README.md is generated from README.Rmd. Please edit that file -->
[![Travis build status](https://travis-ci.org/sflippl/predicode.svg?branch=master)](https://travis-ci.org/sflippl/predicode) [![Coverage status](https://codecov.io/gh/sflippl/predicode/branch/master/graph/badge.svg)](https://codecov.io/github/sflippl/predicode?branch=master)

predicode
=========

Using the package 'predicode', predictive coding networks can easily be instantiated and simulated. Within R, the package can be downloaded from Github. This is easiest using 'devtools':

``` r
# install.packages("devtools")
devtools::install_github("sflippl/predicode")
```

Currently, only fully connected layered architectures may be defined using the function 'layered\_architecture'. This function requires as arguments the size of each layer (layers), the nonlinearity (transformation), and its derivative. For simplicity, a linear predictive coding network is considered, though a nonlinearity could be added using the arguments transformation and derivative.

``` r
arc <- 
    layered_architecture(
        layers = c(4L, 2L)
    )
arc
#> Layered linear architecture with 1 hidden layer.
```

Using the function 'hpc', an input can then be added either as a matrix or as a function that returns a matrix for each time point *t* ∈ ℝ<sub>0</sub><sup>+</sup>.

``` r
# Simulate some Gaussian data
set.seed(328)
params <- randortho(4)[,1:2]
hidden <- matrix(rnorm(200), nrow = 2)
data <- params %*% hidden
hpc <- 
    hpc(
        architecture = arc, 
        input = data
    )
```

The minimal implementation

``` r
impl <- implement_minimal(hpc)
```

may then be investigated using either a simulation (using the function 'simulate') or an analytical trajectory, where the function 'analyse' uses an interface that is consistent with 'simulate' and the functions 'explicit\_inference' and 'explicit\_estimation' provide a sparser interface. The simulations are dependent on the time constants, the timesteps, the initializations, and the stopping rules. As an example, the following code simulates the evolution of the network for 10 s:

``` r
sim <- 
    simulate(
        implementation = impl,
        stopping_rule = stopping_rule(1000),
        tau_estimation = 1,
        tau_inference = 0.01,
        timestep = 0.01
    )
sim
#> # A tibble: 1,001 x 3
#>     time signals    parameters
#>    <dbl> <list>     <list>    
#>  1  0    <list [1]> <list [1]>
#>  2  0.01 <list [1]> <list [1]>
#>  3  0.02 <list [1]> <list [1]>
#>  4  0.03 <list [1]> <list [1]>
#>  5  0.04 <list [1]> <list [1]>
#>  6  0.05 <list [1]> <list [1]>
#>  7  0.06 <list [1]> <list [1]>
#>  8  0.07 <list [1]> <list [1]>
#>  9  0.08 <list [1]> <list [1]>
#> 10  0.09 <list [1]> <list [1]>
#> # … with 991 more rows
```

Explicit solutions are only available for either fixed parameters or isntantaneous signals. 'explicit\_estimation', for example, assumes instantaneous signals:

``` r
# Results are not similar because different random initializations are being used.
est <- 
    explicit_estimation(
        implementation = impl,
        length_time = 10,
        time_constant = 1,
        timestep = 0.01
    )
est
#> # A tibble: 2,002 x 4
#>     time principal_angle lower_bound upper_bound
#>    <dbl>           <int>       <dbl>       <dbl>
#>  1  0                  1       0.912       0.912
#>  2  0                  2       0.375       0.375
#>  3  0.01               1       0.913       0.913
#>  4  0.01               2       0.377       0.378
#>  5  0.02               1       0.914       0.914
#>  6  0.02               2       0.379       0.380
#>  7  0.03               1       0.915       0.916
#>  8  0.03               2       0.381       0.382
#>  9  0.04               1       0.915       0.917
#> 10  0.04               2       0.382       0.385
#> # … with 1,992 more rows
```

The details on the different conceptual level are therefore mostly independent from each other, which makes the package easily extendible with new architectures, new types of input data, or new implementations, for example using the Free Energy Paradigm. Furthermore, the specification of the network abstracts from questions of their investigation that are instead adressed in the functions simulate and analyse. This means that such a package is suitable to collect both all possible versions of predictive coding and all explicit trajectories of these implementation. While the syntax is still subject to revisions, the general principles are assumed to be valuable for further research into predictive coding and related theories.

In particular, using the pipe syntax, which is popular in R and replaces `f(x, y)` by `x %>% f(y)`, the specification of a network can be very concise. An explicit inference analagous to the estimation computed above is (without any prior requirements other than the data simulation) given by:

``` r
c(4L, 2L) %>% 
    layered_architecture() %>% 
    hpc(data) %>% 
    implement_minimal() %>% 
    explicit_inference(
        length_time = 1,
        time_constant = 0.01,
        timestep = 0.01
    )
#> # A tibble: 101 x 3
#>     time untangled_signal tangled_signal 
#>    <dbl> <list>           <list>         
#>  1  0    <dbl [2 × 100]>  <dbl [2 × 100]>
#>  2  0.01 <dbl [2 × 100]>  <dbl [2 × 100]>
#>  3  0.02 <dbl [2 × 100]>  <dbl [2 × 100]>
#>  4  0.03 <dbl [2 × 100]>  <dbl [2 × 100]>
#>  5  0.04 <dbl [2 × 100]>  <dbl [2 × 100]>
#>  6  0.05 <dbl [2 × 100]>  <dbl [2 × 100]>
#>  7  0.06 <dbl [2 × 100]>  <dbl [2 × 100]>
#>  8  0.07 <dbl [2 × 100]>  <dbl [2 × 100]>
#>  9  0.08 <dbl [2 × 100]>  <dbl [2 × 100]>
#> 10  0.09 <dbl [2 × 100]>  <dbl [2 × 100]>
#> # … with 91 more rows
```
