# experimentR: Loading results files of experimental studies

[![CRAN Status Badge](http://www.r-pkg.org/badges/version/experimentR)](http://cran.r-project.org/web/packages/experimentR)
[![CRAN Downloads](http://cranlogs.r-pkg.org/badges/experimentR)](http://cran.rstudio.com/web/packages/experimentR/index.html)
[![CRAN Downloads](http://cranlogs.r-pkg.org/badges/grand-total/experimentR?color=orange)](http://cran.rstudio.com/web/packages/experimentR/index.html)
[![Build Status](https://travis-ci.org/jakobbossek/experimentR.svg?branch=master)](https://travis-ci.org/jakobbossek/experimentR)
[![Build status](https://ci.appveyor.com/api/projects/status/eu0nns2dsgocwntw/branch/master?svg=true)](https://ci.appveyor.com/project/jakobbossek/experimentR/branch/master)
[![Coverage Status](https://coveralls.io/repos/github/jakobbossek/experimentR/badge.svg?branch=master)](https://coveralls.io/github/jakobbossek/experimentR?branch=master)
[![Research software impact](http://depsy.org/api/package/cran/experimentR/badge.svg)](http://depsy.org/package/r/experimentR)

## What is this all about?

The `import` function is the essential contribution of this package. It basically reads a set of results files. However, the magic thing is that you can pass a format string that specifies the folder structure of the result files and automatically extract information, e.g., instance name, replication and parameter settings encoded in the result file path.

## Installation Instructions

The package will be available at [CRAN](http://cran.r-project.org) soon. Install the release version via:
```r
install.packages("experimentR")
```
If you are interested in trying out and playing around with the current github developer version use the [devtools](https://github.com/hadley/devtools) package and type the following command in R:

```r
devtools::install_github("jakobbossek/experimentR")
```

## Contact

Please address questions and missing features about the **experimentR** to the author Jakob Bossek <j.bossek@gmail.com>. Found some nasty bugs? Please use the [issue tracker](https://github.com/jakobbossek/experimentR/issues) for this. Pay attention to explain the problem as good as possible. At its best you provide an example, so I can reproduce your problem quickly.



