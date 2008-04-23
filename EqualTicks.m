(* ::Package:: *)

(* ::Section:: *)
(*Readme*)


(* ::Text:: *)
(*EqualTicks v0.2*)
(*2008 Mar 27*)
(**)
(*The combination of CustomTicks and MathPSfrag results in AxesTicks or FrameTicks that are not equally sized in the two directions. This package fixes that up, but note well that figures that are displayed or exported in the regular (non-MathPSfrag) manner will look wrong!*)
(**)
(*Please send comments and suggestions to me at*)
(*  wspr 81 at gmail dot com *)
(**)
(*Copyright 2008 *)
(*Will Robertson*)


(* ::Section:: *)
(*Licence*)


(* ::Text:: *)
(*This package consists of the files EqualTicks.m and EqualTicks-example.nb. It may be freely distributed and modified under the terms & conditions of the Apache License, v2.0: <http://www.apache.org/licenses/LICENSE-2.0>*)


(* ::Section:: *)
(*Preamble*)


BeginPackage["EqualTicks`","CustomTicks`","MathPSfrag`"];


EqualTicks::usage = "";
XTicks::usage = "";
YTicks::usage = "";
EmptyTicks::usage = "";
EmptyXTicks::usage = "";
EmptyYTicks::usage = "";
XLogTicks::usage = "";
YLogTicks::usage = "";
EmptyXLogTicks::usage = "";
EmptyYLogTicks::usage = "";


Begin["`Private`"]


(* ::Section:: *)
(*Package*)


Options[EqualTicks]={
  FrameTicks -> {XTicks, YTicks, EmptyXTicks, EmptyYTicks},
  Ticks -> {XTicks, YTicks},
  AspectRatio -> 1/GoldenRatio,
  TickLength -> {0.02,0},
  MinorTickLength -> {0.01,0},
  PadRatio -> 1.5
};


ResetEqualTicks := SetOptions[EqualTicks,
  FrameTicks -> {XTicks, YTicks, EmptyXTicks, EmptyYTicks},
  Ticks -> {XTicks, YTicks},
  AspectRatio -> 1/GoldenRatio,
  TickLength -> {0.02,0},
  MinorTickLength -> {0.01,0},
  PadRatio -> 1.5
]


(* ::Subsection:: *)
(*Linear*)


EmptyTicks[a_,b_] := LinTicks[a, b, ShowTickLabels->False]


XTicks[a_,b_,opts___] :=
  LinTicks[a, b,
    MajorTickLength :> 
      OptionValue[EqualTicks,TickLength]/OptionValue[EqualTicks,AspectRatio],
    MinorTickLength :>
      OptionValue[EqualTicks,MinorTickLength]/OptionValue[EqualTicks,AspectRatio] ,
    opts]


YTicks[a_,b_,opts___] :=
  LinTicks[a, b,
    MajorTickLength :> OptionValue[EqualTicks,TickLength],
    MinorTickLength :> OptionValue[EqualTicks,MinorTickLength],
    opts]


EmptyXTicks[a_,b_] := XTicks[a, b, ShowTickLabels -> False]
EmptyYTicks[a_,b_] := YTicks[a, b, ShowTickLabels -> False]


(* ::Subsection:: *)
(*Log*)


XLogTicks[a_,b_,opts___] :=
  LogTicks[10,a, b,
    MajorTickLength :> 
      OptionValue[EqualTicks,TickLength]/OptionValue[EqualTicks,AspectRatio],
    MinorTickLength :>
      OptionValue[EqualTicks,MinorTickLength]/OptionValue[EqualTicks,AspectRatio] ,
    opts]


YLogTicks[a_,b_,opts___] :=
  LogTicks[10,a, b,
    MajorTickLength :> OptionValue[EqualTicks,TickLength],
    MinorTickLength :> OptionValue[EqualTicks,MinorTickLength],
    opts]


EmptyXLogTicks[a_,b_] := XLogTicks[a, b, ShowTickLabels -> False]
EmptyYLogTicks[a_,b_] := YLogTicks[a, b, ShowTickLabels -> False]


(* ::Subsection:: *)
(*Code*)


EqualTicks[fn_,OptionsPattern[]] := Module[{},
  SetOptions[EqualTicks,
    AspectRatio -> OptionValue[AspectRatio],
    TickLength -> OptionValue[TickLength],
    MinorTickLength -> OptionValue[MinorTickLength]
  ];
SetOptions[fn,
    AspectRatio -> OptionValue[AspectRatio],
    FrameTicks -> OptionValue[FrameTicks],
    PlotRangePadding -> {
      Scaled[OptionValue[PadRatio]*
             First[OptionValue[TickLength]]] ,
      Scaled[OptionValue[PadRatio]*
             First[OptionValue[TickLength]]/
             OptionValue[AspectRatio]]}
  ]
]


SetAttributes[EqualTicks,HoldFirst];


(* ::Section:: *)
(*End*)


End[];
EndPackage[];
