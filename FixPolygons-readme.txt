-----------------
FixPolygons v0.2a
2011 Sep 19

This package provides a function of the same name to improve a 
Contour or Region plot by removing all extraneous polygons. It
is only suitable for Mathematica v6.0.x at time of publication.

Such 2D region plots create very complicated graphics based on the 
mesh used to generate the output; these can be simplified with 
an improvement in quality and a decrease in filesize.

Examples and some documentation of the algorithm are shown 
in the supplementary file FixPolygons-example.nb.

This function is now in its 4th incarnation in an effort to improve
its efficiency; it could be further optimised. Please send comments 
and suggestions to us at the email addresses below.

Copyright 2007-2011
Will Robertson		wspr 81 at "gee" mail dot com
Michele Ceriotti	michele dot ceriotti at "gee" mail dot com

-------
History

This package has been written from scratch four times now. Will made the 
first attempt that didn't cover all edge cases and was too slow to be 
useful, before scratching that and writing a useable function that was 
the first release of this package. 

Michele independently did the same thing with a completely different 
algorithm; nonetheless, the result slower than the release version of 
FixPolygons at the time; inspired, that attempt was likewise scratched 
and a new and improved version was written that bested all others. It 
is now the current version of FixPolygons.

* v0.2a (2011/09/19)
    - No code changes; the package (.m) file has been reorganised
      to avoid having code split across blocks (which works fine
      for reading in the package in code but breaks the "Run Package"
      button).

-------
Licence

This package consists of the files FixPolygons.m and 
FixPolygons-example.nb. It may be freely distributed 
and modified under the terms & conditions of the 
Apache License, v2.0: <http://www.apache.org/licenses/LICENSE-2.0>
