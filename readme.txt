------
MMAPKG

This is a collection of small Mathematica packages for making my life 
easier. Along the way, some people have contributed code and ideas of 
their own and their help is acknowledged in the individual packages.

ColorbarPlot:
  Emulates Matlab's colorbar, to an extent. Provides a 
  function with the same name to plot ContourPlots, 
  etc., with an attached colorbar to indicate the range 
  of the data.

FakeRegionPlot:
  Creates a transparent-looking RegionPlot without
  actually using any transparent objects. This is
  essential for exporting to EPS, which doesn't
  support transparency.

FixPolygons:
  Merges adjacent polygons of the same colour to
  produce ContourPlots and RegionPlots of much
  higher quality than Mathematica produces by
  default.

MatlabExport:
  A wrapper around the ToMatlab package that works
  for Greek symbols and derivatives.

EqualTicks:
  A hopefully temporary package to work out some
  problems between MathPSfrag and CustomTicks in
  which tick marks become scaled by the aspect
  ratio of the figure Ñ ugly! Also provides a 
  couple of helper functions that I'll probably
  keep in the future in a package of a different
  name.

That's it for now. Probably more in the future!

Will Robertson