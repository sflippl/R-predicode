
<!-- README.md is generated from README.Rmd. Please edit that file -->
[![Travis build status](https://travis-ci.org/sflippl/predicode.svg?branch=master)](https://travis-ci.org/sflippl/predicode) [![Coverage status](https://codecov.io/gh/sflippl/predicode/branch/master/graph/badge.svg)](https://codecov.io/github/sflippl/predicode?branch=master)

predicode
=========

Implementations of predictive coding networks are widespread, vary in their terminology, and are not always called predictive coding networks. Their rise in popularity within the neuroscience community is widely associated with Rao and Ballard (1999), who used them to explain extraclassical effects in V1. A particularly popular important implementation is the free energy model (see K. Friston 2005), which had been inspired by the Helmholtz machine (Dayan et al. 1995), which had not been called a predictive coding network, but nonetheless corresponded to that concept.

Today, predictive coding as a framework is used to explain various phenomena within the brain. These include mirror neurons (Kilner, Friston, and Frith 2007), binocular rivalry (Hohwy, Roepstorff, and Friston 2008), and self-recognition (Apps and Tsakiris 2014). However, there is no clear consensus on necessary and sufficient conditions for a model to be called predictive coding, calling into question whether this concept is articulated enough to be empirically tested (Kogo and Trengove 2015). Indeed, an often-cited weakness of predictive coding is the universality of this concept:

> If you call everything a predictive coding model, then everything is a predictive coding model.
>
> David Heeger (“NYU Debate: Does Hierarchical Predictive Coding Explain Perception?” 2018, 1:10)

Investigations of predictive coding models would benefit from a more coherent presentation that teases out the key components of predictive coding itself as well as the specifics of the presented implementation.

This package therefore has a normative and a descriptive component to serve my investigation of predictive coding models. On the one hand, I argue that predictive coding models should be defined on a computational level (I will discuss my usage of this term below). On the other hand, I compile existing implementations of predictive coding within this framework. This is, for example, the basis for an investigation of their mathematical equivalence. If the interface and my definition of predictive coding prove themselves as useful, the package would also provide a suitable framework to specify and apply predictive coding implementations.

Installation
------------

You can install the current version of predicode from [Github](https://github.com/sflippl/predicode)

``` r
# install.packages("devtools")
devtools::install_github("sflippl/predicode")
```

References
----------

Apps, Matthew A.J., and Manos Tsakiris. 2014. “The free-energy self: A predictive coding account of self-recognition.” *Neuroscience & Biobehavioral Reviews* 41 (April). Pergamon: 85–97. doi:[10.1016/J.NEUBIOREV.2013.01.029](https://doi.org/10.1016/J.NEUBIOREV.2013.01.029).

Dayan, Peter, Geoffrey E. Hinton, Radford M. Neal, and Richard S. Zemel. 1995. “The Helmholtz Machine.” *Neural Computation* 7 (5). MIT Press 238 Main St., Suite 500, Cambridge, MA 02142‐1046 USA journals-info@mit.edu: 889–904. doi:[10.1162/neco.1995.7.5.889](https://doi.org/10.1162/neco.1995.7.5.889).

Friston, Karl. 2005. “A theory of cortical responses.” *Philosophical Transactions of the Royal Society B* 360: 815–36. doi:[10.1098/rstb.2005.1622](https://doi.org/10.1098/rstb.2005.1622).

Hohwy, Jakob, Andreas Roepstorff, and Karl Friston. 2008. “Predictive coding explains binocular rivalry: An epistemological review.” *Cognition* 108 (3). Elsevier: 687–701. doi:[10.1016/J.COGNITION.2008.05.010](https://doi.org/10.1016/J.COGNITION.2008.05.010).

Kilner, James M., Karl J. Friston, and Chris D. Frith. 2007. “Predictive coding: an account of the mirror neuron system.” *Cognitive Processing* 8 (3). Springer-Verlag: 159–66. doi:[10.1007/s10339-007-0170-2](https://doi.org/10.1007/s10339-007-0170-2).

Kogo, Naoki, and Chris Trengove. 2015. “Is predictive coding theory articulated enough to be testable?” *Frontiers in Computational Neuroscience* 9 (111). Frontiers Media SA: 1–4. doi:[10.3389/fncom.2015.00111](https://doi.org/10.3389/fncom.2015.00111).

“NYU Debate: Does Hierarchical Predictive Coding Explain Perception?” 2018. Accessed December 10. <https://wp.nyu.edu/consciousness/predictive-coding/>.

Rao, Rajesh P. N., and Dana H. Ballard. 1999. “Predictive coding in the visual cortex: a functional interpretation of some extra-classical receptive-field effects.” *Nature Neuroscience* 2 (1). Nature Publishing Group: 79–87. doi:[10.1038/4580](https://doi.org/10.1038/4580).
