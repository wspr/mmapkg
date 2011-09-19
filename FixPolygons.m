(* ::Package:: *)

(* ::Section:: *)
(*Readme*)


(* ::Text:: *)
(*FixPolygons v0.2a*)
(*2011 Sep 19*)
(**)
(*This package provides a function of the same name to improve a *)
(*Contour or Region plot by removing all extraneous polygons. It*)
(*is only suitable for Mathematica v6.0.x at time of publication.*)
(**)
(*Such 2D region plots create very complicated graphics based on the *)
(*mesh used to generate the output; these can be simplified with *)
(*an improvement in quality and a decrease in filesize.*)
(**)
(*Examples and some documentation of the algorithm are shown *)
(*in the supplementary file FixPolygons-example.nb.*)
(**)
(*This function is now in its 4th incarnation in an effort to improve*)
(*its efficiency; it could be further optimised. Please send comments *)
(*and suggestions to us at the email addresses below.*)
(**)
(*Copyright 2007-2011*)
(*Will Robertson		wspr 81 at "gee" mail dot com*)
(*Michele Ceriotti	michele dot ceriotti at "gee" mail dot com*)
(**)


(* ::Section:: *)
(*History*)


(* ::Text:: *)
(*This package has been written from scratch four times now. Will made the first attempt that didn't cover all edge cases and was too slow to be useful, before scratching that and writing a useable function that was the first release of this package. *)
(**)
(*Michele independently did the same thing with a completely different algorithm; nonetheless, the result slower than the release version of FixPolygons at the time; inspired, that attempt was likewise scratched and a new and improved version was written that bested all others. It is now the current version of FixPolygons.*)


(* ::Subsection:: *)
(*v0.2a*)


(* ::Text:: *)
(*No code changes; the package (.m) file has been reorganised to avoid having code split across blocks (which works fine for reading in the package in code but breaks the "Run Package" button).*)


(* ::Section:: *)
(*Licence*)


(* ::Text:: *)
(*This package consists of the files FixPolygons.m and FixPolygons-example.nb. *)
(*It may be freely distributed and modified under the terms & conditions of the Apache License, v2.0:*)
(*   <http://www.apache.org/licenses/LICENSE-2.0>*)


(* ::Section:: *)
(*Package*)


(* ::Subsection:: *)
(*Intro*)


BeginPackage["FixPolygons`"];


FixPolygons::usage =
"FixPolygons[ <graphic> , <options> ]:
  Joins all contiguous polygons into a single shape. 
  This can dramatically improve the image quality and 
  decrease the file size of a ContourPlot or RegionPlot.

Possible options (with defaults) are:
  EarlyCleanupThreshold \[Rule] 1
";

EarlyCleanupThreshold::usage = 
"At every merging iteration, all the vertices
shared by less than EarlyCleanupThreshold polygons are 
deleted. Higher values means that cleanup is faster, but some 
edges might not be removed. The default of 1 leads calls for 
complete cleanup. Sometimes an overall speedup can be 
acheived by applying FixPloygons several times, reducing 
progressively the value of this option from approx. 6 to 1.";


Options[FixPolygons]={
  EarlyCleanupThreshold -> 1
};


Begin["`Private`"]


(* ::Subsection:: *)
(*FixPolygons function*)


(* ::Text:: *)
(*Delve into GraphicsComplex and grab polygons to combine:*)


FixPolygons[graf_,OptionsPattern[FixPolygons]] := 
  graf //. {
    Polygon[{a__},c___],
    Polygon[{b__},c___],d___} ->
      {Polygon[{a,b},c],d} /. 
        {Polygon[{ab__},c___],d___} :>
          {Polygon[cleanup[{ab},
             OptionValue[EarlyCleanupThreshold]],c],d};


(* ::Subsection:: *)
(*Cleanup polygons*)


Module[{vert,uvert,cvert,nvert,i,plist},
cleanup[polylist_,ect_]:=(
  plist = polylist;

(* Makes up a list of the occurrences of vertices in polygon list: *)

  vert = Sort[Flatten[plist]]; 
  uvert = Union[vert]; nvert=Length@uvert;

(* Counts the occurrences of vertices in polygon list: *)

  cvert = Length /@ Split@vert;

(* Preliminary cleanup based on EarlyCleanupThreshold option *)

  vert = DeleteCases[
    Transpose@{uvert,cvert},
	{_,a_}/;a<=ect];

(* Cleans up the vertex list: *)

  Do[
    If[Length@vert==0,Break[]];
    {plist,vert} = refine[{plist,vert},vert[[1,1]],ect];
  ,{i,1,nvert}];

(* Output and finish up, with a final cleanup from residual creaks: *)

  plist //. {{c_,a_,b___,a_} :> {a,b},
	{c___,a_,b_,a_,d___} :> {c,a,d}}
);
];


(* ::Subsection:: *)
(*Clean up vertices of polygons*)


Module[{ri,rj,lvp,nvl,ncl,ppoly,vpoly},
refine[{cl_,vl_},iv_,ect_]:=(

(* Gets the polygons having the shared vertex: *)

  ppoly = Position[cl,{___,iv,___}]; 
  nvl = vl;
  vpoly = cl[[Flatten[ppoly]]];
  lvp = Length@vpoly;

(* Puts all the polygons in a position where the shared vertex is at position 1: *)

  vpoly = Table[
    RotateLeft[vpoly[[ri]],Position[vpoly[[ri]],iv][[1,1]]-1]
  ,{ri,1,lvp}];

(* Finds the neighbours of the polygon to be deleted: *)

  ri = 1;
  rj = 2;
  While[ri <= lvp && rj <= lvp ,
    If[vpoly[[ri,2]] == vpoly[[rj,-1]],
      nvl = nvl /. {vpoly[[ri,2]],a_} :> {vpoly[[ri,2]],a-1};
      vpoly = Prepend[
        Delete[vpoly,{{ri},{rj}}],
		Join[vpoly[[rj]],Drop[vpoly[[ri]],2]]];
	  lvp--;
      ri = rj = 1
    ];
    rj++;
    If[rj==ri, rj++];
    If[rj>lvp, ri++; rj=1];
  ];

(* Cleans up polygons with "creaks": *)

  vpoly = Table[
    vpoly[[ri]] //. {{c_,a_,b___,a_} :> 
     (nvl = (nvl /. {a,e_} :> {a,e-1});
      {a,b}),
	{c___,a_,b_,a_,d___} :> 
     (nvl = (nvl /. {a,e_} :> {a,e-1});
     {c,a,d})}
   ,{ri,1,lvp}];
  ncl = Join[Delete[cl,ppoly],vpoly];
  nvl = DeleteCases[nvl,{iv,_}|{_,a_}/;a<=ect];

(* Output and finish: *)

  {ncl,nvl}
);
];


(* ::Subsection:: *)
(*End*)


End[];
EndPackage[];
