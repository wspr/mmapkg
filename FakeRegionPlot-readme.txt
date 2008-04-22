___________________
FakeRegionPlot v0.2
23 April 2008

Creates a RegionPlot using contiguous, rather than overlapping, regions. This allows export to EPS directly without having transparent colours destroyed (or rather, made fully opaque) in the process.

This package has been written with and for Mathematica 6.0.x.

Please send comments and suggestions to wspr 81 at gmail dot com.

Copyright 2007 
Will Robertson

_____
To-do

Better default colours (match RegionPlot)
I doubt that all PlotStyle/BoundaryStyle options are supported.
Real alpha transparency calculations; this needs a user interface, too.
E.g., <http://en.wikipedia.org/wiki/Alpha_compositing>

_______
Changes

v0.0
Initial version, of course.

v0.1
Some support for BoundaryStyle

v0.2, Apr 2008
Added a ReleaseHold in case the evaluation of regions need to be delayed.
Added Lighten option to allow customising the fake transparency. Not happy with it yet.
Pass through the MaxRecursion to both the boundary and the region plotting.