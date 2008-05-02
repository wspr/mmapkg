___________________
FakeRegionPlot v0.2
2 May 2008

Creates a RegionPlot using contiguous, rather than overlapping, regions. This allows export to EPS directly without having transparent colours destroyed (or rather, made fully opaque) in the process. As well as being a fairly widely used graphics format (still), EPS export is required for LATEX documents (that aren't using pdfTeX to produce PDF files directly) and, in particular, Johannes Gro§e's MathPSfrag package.

An example/documentation notebook, FakeRegionPlot-example.nb, is distributed with this package. FakeRegionPlot has been written with and for Mathematica 6.0.x. 

Please send comments and suggestions to wspr 81 at gmail dot com. The official location for the source of this package is: http://github.com/wspr/mmapkg/tree/master .

Copyright 2007-2008
Will Robertson

_____
To-do

Better default colours (match RegionPlot)

I doubt that all PlotStyle/BoundaryStyle options are supported.

_______
Changes

v0.0

Initial version, of course.

v0.1

Some support for BoundaryStyle

v0.2, May 2008

Added a ReleaseHold in case the evaluation of regions need to be delayed.

Added Opacity option to allow customising the fake transparency. The calculation is a proper imitation of transparency, now, rather than a fudge.

Pass through the MaxRecursion to both the boundary and the region plotting.

_______
Licence

This package consists of the files FakeRegionPlot.m and FakeRegionPlot-example.nb. It may be freely distributed and modified under the terms & conditions of the Apache License, v2.0: <http://www.apache.org/licenses/LICENSE-2.0>