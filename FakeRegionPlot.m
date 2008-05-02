(* ::Package:: *)

(* ::Title:: *)
(*Readme*)


(* ::Text:: *)
(*FakeRegionPlot v0.2*)
(*2 May 2008*)
(**)
(*Creates a RegionPlot using contiguous, rather than overlapping, regions. This allows export to EPS directly without having transparent colours destroyed (or rather, made fully opaque) in the process. As well as being a fairly widely used graphics format (still), EPS export is required for L AT EX documents (that aren't using pdfTeX to produce PDF files directly) and, in particular, Johannes Gro\[SZ]e's MathPSfrag package.*)
(**)
(*An example/documentation notebook, FakeRegionPlot-example.nb, is distributed with this package. FakeRegionPlot has been written with and for Mathematica 6.0.x. *)
(**)
(*Please send comments and suggestions to wspr 81 at gmail dot com. The official location for the source of this package is: http://github.com/wspr/mmapkg/tree/master .*)
(**)
(*Copyright 2007-2008*)
(*Will Robertson*)


(* ::Title:: *)
(*To-do*)


(* ::Text:: *)
(*Better default colours (match RegionPlot)*)


(* ::Text:: *)
(*I doubt that all PlotStyle/BoundaryStyle options are supported.*)


(* ::Title:: *)
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
(*v0.2, May 2008*)


(* ::Text:: *)
(*Added a ReleaseHold in case the evaluation of regions need to be delayed.*)


(* ::Text:: *)
(*Added Opacity option to allow customising the fake transparency. The calculation is a proper imitation of transparency, now, rather than a fudge.*)


(* ::Text:: *)
(*Pass through the MaxRecursion to both the boundary and the region plotting.*)


(* ::Title:: *)
(*Licence*)


(* ::Text:: *)
(*This package consists of the files FakeRegionPlot.m and FakeRegionPlot-example.nb. It may be freely distributed and modified under the terms & conditions of the Apache License, v2.0: <http://www.apache.org/licenses/LICENSE-2.0>*)


(* ::Title:: *)
(*Preamble*)


BeginPackage["FakeRegionPlot`"];


FakeRegionPlot::usage = 
"FakeRegionPlot: use similarly to RegionPlot; creates a figure 
that shows overlapping regions WITHOUT using transparency. 
This allows correct export to EPS, unlike regular RegionPlot.

Options interpreted by FakeRegionPlot:
    PlotStyle -> Blue  |  {list, of, colours}
    BoundaryStyle -> Blue  |  {list, of, colours}
    Opacity -> 0.25  |  {list, of, opacities}

If not specified, the BoundaryStyle colours are infered from
the PlotStyle colours.

All other options are passed through to RegionPlot.";

FakeRegionPlot::colorerror = 
"The specification of colours/opacities must either 
be a single colour/value or a list with as many 
colours/values as regions.";

FakeRegionPlot::opaval = 
"The opacity must be specified between 0 and 1. 
The default value is 0.25.";


Begin["`Private`"]


(* ::Title:: *)
(*Package*)


(* ::Section:: *)
(*Options*)


Options[FakeRegionPlot]={
  PlotStyle -> Blue,
  BoundaryStyle -> Null,
  Opacity -> 1/4,
  MaxRecursion -> Automatic
};


(* ::Section:: *)
(*Helper functions*)


(* ::Text:: *)
(*Creates combinations of list elements:*)


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
(*ListCombinations[1-{a,b,c},Times,MakeNull]*)


(* ::Text:: *)
(*This function blends (lists of) colours to imitate transparency:*)


MakeColors[cols_List,opa_List] := 
  MapThread[
    Blend@Flatten@{#1,#1}& @ Lighter[#1,#2] &,
   {ListCombinations[cols,List,MakeNull],
    ListCombinations[1-opa,Times,MakeNull]}];


(* ::Section:: *)
(*FakeRegionPlot*)


FakeRegionPlot[reg_List,xx_List,yy_List,opts___] := 
  Module[{Opt,l,cols,bounds,bopt,opa},








(* ::Subsection:: *)
(*Option processing*)


  Opt[x_] := OptionValue[FakeRegionPlot,
         FilterRules[{opts},Options[FakeRegionPlot]],x];


(* ::Subsection::Closed:: *)
(*Input parsing*)


(* ::Text:: *)
(*All of the inputs for styling take either a single value input or a list of size equal to the number of regions. The code for parsing this should be abstracted\[Ellipsis]*)


(* ::Subsubsection:: *)
(*PlotStyle*)


  l = Length@reg;
  If[Head[Evaluate@Opt@PlotStyle] === List,
  (* Multicolour: *)
    If[Length@Opt@PlotStyle == l,
      cols = Opt@PlotStyle,
      Message[FakeRegionPlot::colorerror]],
  (* Single colour: *)
    cols = Table[Opt@PlotStyle,{l}]];


(* ::Subsubsection:: *)
(*BoundaryStyle*)


(* ::Text:: *)
(*If no BoundaryStyle is specified, then use PlotStyle instead:*)


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


(* ::Subsubsection:: *)
(*Opacity*)


  If[Head[opa=Evaluate@Opt@Opacity] === List,
  (* Multiple opacities: *)
    If[Length@opa == l,
      If[Not[And@@(0<#<1&/@opa)],
        Message[FakeRegionPlot::colorerror]],
      Message[FakeRegionPlot::colorerror]],
  (* Single opacity: *)
    opa = Table[Opt@Opacity,{l}]];


(* ::Subsection:: *)
(*Drawing the plot*)


  Show[








(* ::Subsubsection:: *)
(*Regions*)


  Show@MapThread[
    RegionPlot[ReleaseHold[#1],xx,yy,
      PlotStyle -> #2,
      BoundaryStyle -> None,








(* ::Text:: *)
(*All options that are applicable to RegionPlot are passed through. (This includes MaxRecusion.) But the assignments to PlotStyle and BoundaryStyle are already in effect.*)


      Evaluate@FilterRules[{opts},Options@RegionPlot]]&,
    {ListCombinations[reg,And,Not],
     MakeColors[cols,opa]}],








(* ::Subsubsection:: *)
(*Boundaries*)


(* ::Text:: *)
(*Splitting up the drawing of the regions to have overlapping areas drawn separately to the boundaries means that even if the colour is dodgy due to low MaxRecursion, at least the outside edge will look okay.*)


  Show@MapThread[RegionPlot[#1,xx,yy,
    PlotStyle->None,
    MaxRecursion->Opt@MaxRecursion,
    BoundaryStyle->#2]&,{reg,bounds}]


(* ::Subsubsection:: *)
(*End plot*)


]


(* ::Subsection:: *)
(*End FakeRegionPlot*)


]


(* ::Section:: *)
(*End*)


End[];
EndPackage[];
