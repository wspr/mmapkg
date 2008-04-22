(* ::Package:: *)

(* ::Section:: *)
(*Readme*)


(* ::Text:: *)
(*FakeRegionPlot v0.2*)
(*23 April 2008*)
(**)
(*Creates a RegionPlot using contiguous, rather than overlapping, regions. This allows export to EPS directly without having transparent colours destroyed (or rather, made fully opaque) in the process.*)
(**)
(*This package has been written with and for Mathematica 6.0.x.*)
(**)
(*Please send comments and suggestions to wspr 81 at gmail dot com.*)
(**)
(*Copyright 2007 *)
(*Will Robertson*)


(* ::Section:: *)
(*To-do*)


(* ::Text:: *)
(*Better default colours (match RegionPlot)*)


(* ::Text:: *)
(*I doubt that all PlotStyle/BoundaryStyle options are supported.*)


(* ::Text:: *)
(*Real alpha transparency calculations; this needs a user interface, too.*)
(*E.g., <http://en.wikipedia.org/wiki/Alpha_compositing>*)


(* ::Section:: *)
(*Changes*)


(* ::Subsubsection:: *)
(*v0.0*)


(* ::Text:: *)
(*Initial version, of course.*)


(* ::Subsubsection:: *)
(*v0.1*)


(* ::Text:: *)
(*Some support for BoundaryStyle*)


(* ::Subsubsection:: *)
(*v0.2, Apr 2008*)


(* ::Text:: *)
(*Added a ReleaseHold in case the evaluation of regions need to be delayed.*)


(* ::Text:: *)
(*Added Lighten option to allow customising the fake transparency. Not happy with it yet.*)


(* ::Text:: *)
(*Pass through the MaxRecursion to both the boundary and the region plotting.*)


(* ::Section:: *)
(*Licence*)


(* ::Text:: *)
(*This package consists of the files FakeRegionPlot.m and FakeRegionPlot-example.nb. It may be freely distributed and modified under the terms & conditions of the Apache License, v2.0: <http://www.apache.org/licenses/LICENSE-2.0>*)


(* ::Section:: *)
(*Preamble*)


BeginPackage["FakeRegionPlot`"];


FakeRegionPlot::usage =
"FakeRegionPlot: use like RegionPlot; creates a 
figure that shows overlapping regions WITHOUT using
transparency. This allows correct export to EPS, 
unlike regular RegionPlot.";

FakeRegionPlot::colorerror = "
    The number of colours must either be 
    one or equal to the number of regions.";


Begin["`Private`"]


(* ::Section:: *)
(*Package*)


Options[FakeRegionPlot]={
  PlotStyle -> Blue,
  BoundaryStyle -> Null,
  Lighten -> 1/4,
  MaxRecursion -> Automatic
};


(* ::Text:: *)
(*I can't really remember how this works:*)


ListCombinations[in_List,AND_,NOT_] := Module[{s,x},
  s = Tuples[{#&,NOT[#]&},Length@in];
  s = Thread[MyApply[#,in]]& /@ s/.MyApply[x_,y_]->x[y];
  s = AND@@#& /@ s;
  Most@s (* Last element is "NOT all" -- we're not using that one *)
]


MakeNull[_] := Sequence[]


(* ::Input:: *)
(*ListCombinations[{a,b,c},And,Not]*)
(*ListCombinations[{a,b,c},List,MakeNull]*)


(* ::Text:: *)
(*This function blends colours to approximate transparency.*)


MakeColors[cols_List,l_] := Module[{p,t},
  p = Length@cols+1;
  t = ListCombinations[cols,List,MakeNull];
  Nest[Lighter[#,l]&,Blend[Flatten[{#,#}]],p-Length[#]-1]& /@ t
]


(* ::Text:: *)
(*And here's the main function:*)


FakeRegionPlot[reg_List,xx_List,yy_List,opts___] := 
  Module[{Opt,l,cols,bounds,bopt},

  (* Option processing *)
  Opt[x_] := OptionValue[FakeRegionPlot,
         FilterRules[{opts},Options[FakeRegionPlot]],x];

  (* Setup *)
  l = Length@reg;
  If[Head[Evaluate@Opt@PlotStyle] === List,
  (* Multicolour: *)
    If[Length@Opt@PlotStyle == l,
      cols = Opt@PlotStyle,
      Message[FakeRegionPlot::colorerror]],
  (* Single colour: *)
    cols = Table[Opt@PlotStyle,{l}]];

  If[Evaluate@Opt@BoundaryStyle === Null,
    (* Get the PlotStyle default: *)
    bopt = Evaluate@Opt@PlotStyle,
    bopt = Evaluate@Opt@BoundaryStyle];

  If[Head[bopt] === List,
  (* Multicolour: *)
    If[Length@bopt == l,
      bounds = bopt,
      Message[FakeRegionPlot::colorerror]],
  (* Single colour: *)
    bounds = Table[bopt,{l}]];

  Show[
  (* Insides: *)
  Show@MapThread[
    RegionPlot[ReleaseHold[#1],xx,yy,
      PlotStyle -> #2,
      BoundaryStyle -> None,
      Evaluate@FilterRules[{opts},Options@RegionPlot]]&,
    {ListCombinations[reg,And,Not],MakeColors[cols,Opt@Lighten]}],
  (* Boundaries: *) 
  Show@MapThread[RegionPlot[#1,xx,yy,
    PlotStyle->None,
    MaxRecursion->Opt@MaxRecursion,
    BoundaryStyle->#2]&,{reg,bounds}]]]


(* ::Text:: *)
(*Splitting up the drawing of the regions to have overlapping areas drawn separately to the boundaries means that even if the colour is dodgy due to low MaxRecursion, at least the outside edge will look okay.*)


(* ::Section:: *)
(*End*)


End[];
EndPackage[];
