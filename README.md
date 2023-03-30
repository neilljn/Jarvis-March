# Jarvis-March

This is an R package containing functions for finding the convex hull of a dataset (of points in 2 dimensions) using the Jarvis-March algorithm.

## Installing the package

First we must load the `devtools` package for installation and the `ggplot2` package for plotting. (If you do not have these packages installed, you must do so beforehand.)
```
library(devtools)
library(ggplot2)
```

This means we can now install the `JarvisMarch` package using the following code:
```
install_github("neilljn/JarvisMarch")
library(JarvisMarch)
```

## Using the package

This package contains three primary functions: `jarivs_march`, `plot_hull`, and `in_hull`. Two other functions (`jarivs_march_points` and `error_checking`) are used by the three main functions and not intended for direct use - but are provided and have full help files if the user wants to examine how the package works.

The first function is `jarvis_march`. This function takes one input,`dataset`: a list of vectors, where each vector is of length 2 - representing a point $(x,y)$ in the 2-dimensional plane. This is the data we will find the convex hull of, producing an output: a list of vectors, where each vector is of length 4 - $(x_0,y_0,x_1,y_1)$, representing a line segment between $(x_0,y_0)$ and $(x_1,y_1)$. The input `dataset` may instead be a dataframe (with 2 columns) or a single vector (where the points are concatonated into one sequence).
```
jarvis_march(dataset)
```

The `plot_hull` function also takes a single input `dataset` in the same format as above (list, dataframe, or vector). However, it instead outputs a plot of the data (points in black) and the convex hull of that data (points and line segment in red). The outputted plot is a `ggplot2` object.
```
plot_hull(dataset)
```

The `in_hull` function takes two inputs: `dataset` and `pointset`. Both inputs must be of the same format as above (list, dataframe, or vector). This function computes the convex hull of `dataset`, and then assesses the relationship of each point in `pointset` to the convex hull. This is outputted as a list, where each entry is one of the following:
- a vertex of the convex hull
- on an edge of the convex hull (but not a vertex)
- inside the convex hull
- outside the convex hull
```
in_hull(dataset,pointset)
```

## More about the Jarvis-March algorithm

For more information on the functions provided, see the R help files. 

For examples of the functions being used, see the _Cplusplus_linking_with_R_Assessment_ jupyer notebook.

Additional implementations of the Jarvis-March algorithm in Python and C++ can be found in the _Python_Assessment_ and _Cplusplus_Assessment_ jupyter notebooks respectively. A comparision of the three implementations can be found in the _Cplusplus_linking_with_R_Assessment_ jupyer notebook.

All three implementations of the Jarvis-March algorithm are based on the following pseudocode:
1) Let the dataset be $X$.
2) If the $X$ has only 1 or 2 elements, return $X$ as the hull.
3) Check if all points in $X$ lie on a straight line - if so, return $X$ as the hull.
4) Let $p_0$ be the leftmost point in $X$, and let $p=p_0$.
5) Let $H$ be a list containing only $p_0$.
6) Let $P$ be an empty list.
7) For each point $q \in X \backslash \{p\}$, consider the ACW angle $pqr$ for all points $r \in X \backslash \{p,q\}$ - if the ACW angle is always between $0$ and $\pi$, then append $q$ to $P$.
8) Let $p'$ be the value in $P$ closest to the current value of $p$.
9) Let $p=p'$, and append the new $p$ to $H$.
10) If $p \neq p_0$, go to step 6.
11) Return $H$ as our covex hull.
